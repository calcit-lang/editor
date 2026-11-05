import { execFileSync } from "node:child_process";
import { closeSync, constants, copyFileSync, existsSync, lstatSync, mkdirSync, mkdtempSync, openSync, readFileSync, renameSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { createHash, randomUUID } from "node:crypto";
import {
  CalcitCirruQuote, format_cirru_edn, parse_cirru_edn, newTag,
  _$n__$M_ as calcitMap, _$L_ as calcitList,
  map_$q_ as isCalcitMap, enum_$q_ as isCalcitEnum, tag_$q_ as isCalcitTag,
  list_$q_ as isCalcitList, _$n_list_$o_count as listCount, _$n_list_$o_nth as listAt,
  _$n_enum_$o_nth as enumAt, _$n_enum_$o_count as enumCount,
} from "@calcit/procs";

/** Replace editable fields in an official CLI entry view, retaining all metadata. */
export function updateSourceEntry(sourceView, syntax, doc) {
  const isSyntax = node => typeof node === "string" ||
    (Array.isArray(node) && node.every(isSyntax));
  if (typeof sourceView !== "string" || typeof doc !== "string" ||
      !Array.isArray(syntax) || !syntax.every(isSyntax)) {
    throw new TypeError("Source entries require an official view, syntax token tree and documentation string.");
  }
  const entry = parse_cirru_edn(sourceView);
  if (!entry || ![newTag("NsEntry"), newTag("CodeEntry")].includes(entry.name) ||
      typeof entry.assoc !== "function" ||
      !(entry.getRequired(newTag("code")) instanceof CalcitCirruQuote)) {
    throw new TypeError("Expected an official NsEntry or CodeEntry view.");
  }
  return format_cirru_edn(entry
    .assoc(newTag("code"), new CalcitCirruQuote(syntax))
    .assoc(newTag("doc"), doc));
}

export class SnapshotRevisionConflict extends Error {
  constructor(expected, actual, subject = "Snapshot") {
    super(`The project ${subject} changed outside this editor session; reload it before saving.`);
    this.name = "SnapshotRevisionConflict";
    this.expected = expected;
    this.actual = actual;
  }
}

function run(snapshot, args, calcitBin) {
  return execFileSync(calcitBin, [snapshot, ...args], {
    cwd: dirname(snapshot),
    encoding: "utf8",
    stdio: ["ignore", "pipe", "pipe"],
    maxBuffer: 16 * 1024 * 1024,
  });
}

const query = (snapshot, args, calcitBin) => JSON.parse(run(snapshot, args, calcitBin));

/** @param {string} snapshot @param {{calcitBin?: string}} [options] @returns {string} */
export function readSnapshotRevision(snapshot, { calcitBin = "calcit" } = {}) {
  const result = query(resolve(snapshot), ["query", "config", "--format", "json"], calcitBin);
  if (typeof result.revision !== "string" || result.revision.length === 0) {
    throw new Error("Calcit did not return a Snapshot revision.");
  }
  return result.revision;
}

/** Fingerprint dependency metadata independently of the CLI Snapshot revision. */
function manifestRevision(directory) {
  const file = join(directory, "deps.cirru");
  return existsSync(file) ? `sha256:${createHash("sha256").update(readFileSync(file)).digest("hex")}` : "missing";
}

/**
 * Read syntax/metadata views without compiling or executing the user's program.
 * @param {string} snapshot
 * @param {{calcitBin?: string}} [options]
 * @returns {{revision: string, manifestRevision: string, config: Record<string, unknown>, namespaceViews: {name: string, entry: string}[], entryTemplates: {file: string, ns: string, def: string}}}
 */
export function readSnapshot(snapshot, { calcitBin = "calcit" } = {}) {
  const path = resolve(snapshot);
  const staging = mkdtempSync(join(tmpdir(), "calcit-editor-read-"));
  try {
    // One opaque copy keeps all namespace queries on the same source bytes.
    const copy = join(staging, "calcit.cirru");
    copyFileSync(path, copy);
    const deps = join(dirname(path), "deps.cirru");
    if (existsSync(deps)) copyFileSync(deps, join(staging, "deps.cirru"));
    const copiedManifestRevision = manifestRevision(staging);
    const config = query(copy, ["query", "config", "--format", "json"], calcitBin);
    const index = query(copy, ["query", "ns", "--format", "json"], calcitBin).data;
    const generated = new Set(index.generated);
    const namespaceViews = index.namespaces.filter(name => !generated.has(name)).map(name => ({
      name,
      entry: run(copy, ["query", "ns", name, "--format", "cirru"], calcitBin),
    }));
    // Ask the same official CLI for new-entry defaults, only after all source
    // views have been read from the original copy. Never edit the user's file.
    const templateNamespace = `${config.data.package}.calcit-editor-source-template-${randomUUID().replaceAll("-", "")}`;
    applySnapshotTransaction(copy, config.revision, [
      ["edit", "add-ns", templateNamespace],
      ["edit", "def", `${templateNamespace}/entry-template`, "--input-format", "json-ast",
        "--code", JSON.stringify(["def", "entry-template", "nil"])],
    ], { calcitBin });
    const templateView = run(copy, ["query", "ns", templateNamespace, "--format", "cirru"], calcitBin);
    const templateFile = parse_cirru_edn(templateView);
    const templateDef = templateFile.getRequired(newTag("defs")).pairs()
      .find(([name]) => name.value === "entry-template")[1];
    const entryTemplates = {
      file: templateView,
      ns: format_cirru_edn(templateFile.getRequired(newTag("ns"))),
      def: format_cirru_edn(templateDef),
    };
    const current = readSnapshotRevision(path, { calcitBin });
    if (config.revision !== current) throw new SnapshotRevisionConflict(config.revision, current);
    const currentManifestRevision = manifestRevision(dirname(path));
    if (copiedManifestRevision !== currentManifestRevision) {
      throw new SnapshotRevisionConflict(copiedManifestRevision, currentManifestRevision, "dependency manifest");
    }
    // Keep FileEntry views opaque here; do not duplicate its metadata schema.
    return { revision: current, manifestRevision: copiedManifestRevision, config: config.data, namespaceViews, entryTemplates };
  } finally {
    rmSync(staging, { recursive: true, force: true });
  }
}

/**
 * Apply official CLI argv rows, without reconstructing FileEntry/CodeEntry data.
 * Planning the editor diff and importing the resulting program are separate steps.
 * The session caches the whole Snapshot, so use a global revision: accepting an
 * unrelated external edit here would leave the cached editor database stale.
 * @param {string} snapshot
 * @param {string} expectedRevision
 * @param {string[][]} operations
 * @param {{calcitBin?: string}} [options]
 * @returns {{changed: boolean, revision: string}}
 */
export function applySnapshotTransaction(snapshot, expectedRevision, operations, { calcitBin = "calcit" } = {}) {
  if (typeof expectedRevision !== "string" || expectedRevision.length === 0) {
    throw new TypeError("Saving requires the revision imported by this editor session.");
  }
  if (!Array.isArray(operations) || !operations.every(row =>
    Array.isArray(row) && row.length > 0 && row.every(arg => typeof arg === "string"))) {
    throw new TypeError("Snapshot operations must be arrays of CLI string arguments.");
  }
  const path = resolve(snapshot);
  const current = readSnapshotRevision(path, { calcitBin });
  if (current !== expectedRevision) throw new SnapshotRevisionConflict(expectedRevision, current);
  if (operations.length === 0) return { changed: false, revision: current };

  const staging = mkdtempSync(join(tmpdir(), "calcit-editor-transaction-"));
  try {
    const file = join(staging, "operations.json");
    writeFileSync(file, JSON.stringify(operations), { mode: 0o600 });
    const args = ["edit", "transaction", "--file", file];
    const preview = query(path, [...args, "--dry-run", "--format", "json"], calcitBin);
    if (preview.original_revision !== expectedRevision) {
      throw new SnapshotRevisionConflict(expectedRevision, preview.original_revision);
    }
    // The CLI lock and global precondition also reject changes after the dry-run.
    // No text-serialization fallback is allowed when the CLI rejects the edit.
    const applied = query(path, [...args, "--expect-revision", expectedRevision, "--format", "json"], calcitBin);
    if (typeof applied.new_revision !== "string" || typeof applied.changed !== "boolean") {
      throw new Error("Calcit did not return a transaction result.");
    }
    return { changed: applied.changed, revision: applied.new_revision };
  } finally {
    rmSync(staging, { recursive: true, force: true });
  }
}

/**
 * Serialize the CLI read frame for the checked Calcit-owned project importer.
 * These Maps describe editor input; they are never a reconstructed Snapshot.
 * The complete CLI config remains opaque JSON alongside the editable projection.
 * @param {string} snapshot
 * @param {{calcitBin?: string}} [options]
 * @returns {string}
 */
export function readSnapshotEdn(snapshot, options) {
  const frame = readSnapshot(snapshot, options);
  const tagMap = entries => calcitMap(...Object.entries(entries).flatMap(([key, value]) => [newTag(key), value]));
  const stringMap = entries => calcitMap(...entries.flatMap(([key, value]) => [key, value]));
  const entryConfig = entry => tagMap({
    "init-fn": entry.init_fn,
    "reload-fn": entry.reload_fn,
    modules: calcitList(...entry.modules),
    mode: newTag(entry.mode),
    target: entry.target == null ? null : newTag(entry.target),
    description: entry.description,
  });
  const primary = frame.config.entries.find(entry => entry.name === "default");
  if (!primary) throw new Error("The CLI did not return the default project entry.");
  return format_cirru_edn(tagMap({
    "source-revision": frame.revision,
    "source-manifest-revision": frame.manifestRevision,
    "source-config": JSON.stringify(frame.config),
    package: frame.config.package,
    configs: entryConfig(primary).assoc(newTag("version"), frame.config.version),
    entries: stringMap(frame.config.entries.filter(entry => entry.name !== "default").map(entry => [entry.name, entryConfig(entry)])),
    "namespace-views": stringMap(frame.namespaceViews.map(({name, entry}) => [name, entry])),
    "source-templates": tagMap(frame.entryTemplates),
  }));
}

/**
 * Save explicit namespace changes through the CLI's atomic transaction API.
 * Requires edit ns transaction support, validated with official Calcit 0.34.3,
 * and a CLI matching the target project pin. Calcit 0.34.2 lacks this feature.
 * The EDN input is Map<String, Option<String>>: Some replaces a full official
 * namespace view, None removes a namespace. Untouched namespaces/config stay
 * owned by the CLI. Namespace views use files to avoid OS argument-size limits.
 * @param {string} snapshot
 * @param {string} expectedRevision
 * @param {string} changesEdn
 * @param {{calcitBin?: string}} [options]
 * @returns {string}
 */
export function writeSnapshotChangesEdn(snapshot, expectedRevision, changesEdn, options = {}) {
  return writeSourceChanges(snapshot, expectedRevision, changesEdn, null, options);
}

/** Save namespace and editable entry configuration changes in one CLI transaction. */
export function writeProjectChangesEdn(snapshot, expectedRevision, changesEdn, settingsEdn, options = {}) {
  return writeSourceChanges(snapshot, expectedRevision, changesEdn, parse_cirru_edn(settingsEdn), options);
}

function writeSourceChanges(snapshot, expectedRevision, changesEdn, settings, { calcitBin = "calcit" } = {}) {
  const changes = parse_cirru_edn(changesEdn);
  if (!isCalcitMap(changes)) throw new TypeError("Expected namespace changes as Map<String, Option<String>>.");
  const rows = changes.pairs().map(([namespace, change]) => {
    if (typeof namespace !== "string" || !isCalcitEnum(change)) {
      throw new TypeError("Expected namespace changes as Map<String, Option<String>>.");
    }
    const variant = enumAt(change, 0).value;
    if (variant === "none" && enumCount(change) === 1) return [namespace, null];
    if (variant === "some" && enumCount(change) === 2 && typeof enumAt(change, 1) === "string") {
      return [namespace, enumAt(change, 1)];
    }
    throw new TypeError("Expected namespace changes as Map<String, Option<String>>.");
  });
  rows.sort(([left], [right]) => left < right ? -1 : left > right ? 1 : 0);
  const path = resolve(snapshot);
  const index = rows.length ? query(path, ["query", "ns", "--format", "json"], calcitBin).data : null;
  const existing = new Set(index?.namespaces ?? []);
  const staging = mkdtempSync(join(tmpdir(), "calcit-editor-save-"));
  try {
    const operations = settings === null ? [] : planConfiguration(
      query(path, ["query", "config", "--format", "json"], calcitBin).data,
      settings,
    );
    for (const [namespace, view] of rows) {
      if (view === null) operations.push(["edit", "rm-ns", namespace]);
      else {
        if (!existing.has(namespace)) operations.push(["edit", "add-ns", namespace]);
        const file = join(staging, `${operations.length}.cirru`);
        writeFileSync(file, view, { mode: 0o600 });
        operations.push(["edit", "ns", namespace, "--file", file, "--allow-remove"]);
      }
    }
    const applied = applySnapshotTransaction(path, expectedRevision, operations, { calcitBin });
    return format_cirru_edn(calcitMap(
      newTag("changed"), applied.changed,
      newTag("source-revision"), applied.revision,
    ));
  } finally {
    rmSync(staging, { recursive: true, force: true });
  }
}

/** Translate only the Editor's editable projection; hidden CLI metadata stays intact. */
function planConfiguration(current, settings) {
  const fields = (value, label) => {
    if (!isCalcitMap(value)) throw new TypeError(`${label} must be a Map with Tag keys.`);
    return new Map(value.pairs().map(([key, item]) => {
      if (!isCalcitTag(key)) throw new TypeError(`${label} requires Tag keys.`);
      return [key.value, item];
    }));
  };
  const text = (value, label) => {
    if (typeof value !== "string") throw new TypeError(`${label} must be String.`);
    return value;
  };
  const tagText = (value, label) => {
    if (!isCalcitTag(value)) throw new TypeError(`${label} must be Tag.`);
    return value.value;
  };
  const modules = value => {
    if (!isCalcitList(value)) throw new TypeError("modules must be List<String>.");
    return Array.from({ length: listCount(value) }, (_, index) => text(listAt(value, index), "module"));
  };
  const root = fields(settings, "project settings");
  for (const key of root.keys()) if (!["configs", "entries"].includes(key)) throw new Error(`Unsupported project setting ${key}.`);
  const configs = fields(root.get("configs"), "configs");
  if (configs.has("version") && configs.get("version") !== current.version) {
    throw new Error("Project version is managed by deps.cirru; use caps version set and reload the project.");
  }
  const desired = root.get("entries");
  if (!isCalcitMap(desired)) throw new TypeError("entries must be Map<String, Map<Tag, Dynamic>>.");
  const next = new Map(desired.pairs().map(([name, value]) => [text(name, "entry name"), fields(value, "entry")]));
  if (next.has("default")) throw new Error("Edit the default entry in configs, not entries.");
  next.set("default", configs);
  const previous = new Map(current.entries.map(entry => [entry.name, entry]));
  const operations = [];
  for (const name of previous.keys()) {
    if (name !== "default" && !next.has(name)) operations.push(["config", "unset", "--entry", name, "entry"]);
  }
  for (const [name, requested] of next) {
    const allowed = name === "default" ? ["version", "port", "expose-port"] : [];
    for (const key of requested.keys()) {
      if (!["mode", "target", "init-fn", "reload-fn", "description", "modules", ...allowed].includes(key)) {
        throw new Error(`Unsupported editable entry field ${key}; its CLI-owned metadata is preserved.`);
      }
    }
    const old = previous.get(name);
    const mode = requested.has("mode") ? tagText(requested.get("mode"), "mode") : old?.mode;
    const init = requested.has("init-fn") ? text(requested.get("init-fn"), "init-fn") : old?.init_fn;
    const reload = requested.has("reload-fn") ? text(requested.get("reload-fn"), "reload-fn") : old?.reload_fn;
    if (!old) {
      if (mode === undefined || init === undefined || reload === undefined) throw new Error("New entries require mode, init-fn and reload-fn.");
      operations.push(["config", "add-entry", name, "--mode", mode, "--init-fn", init, "--reload-fn", reload]);
    }
    const scope = ["--entry", name];
    let oldTarget = old?.target ?? null;
    if (old && mode !== old.mode && oldTarget !== null) {
      operations.push(["config", "unset", ...scope, "target"]);
      oldTarget = null;
    }
    if (old && mode !== old.mode) operations.push(["config", "set", ...scope, "mode", mode]);
    if (old && init !== old.init_fn) operations.push(["config", "set", ...scope, "init-fn", init]);
    if (old && reload !== old.reload_fn) operations.push(["config", "set", ...scope, "reload-fn", reload]);
    if (requested.has("target")) {
      const target = requested.get("target") === null ? null : tagText(requested.get("target"), "target");
      if (target !== oldTarget) operations.push(target === null ? ["config", "unset", ...scope, "target"] : ["config", "set", ...scope, "target", target]);
    } else if (old && old.target !== null && mode !== old.mode) {
      operations.push(["config", "set", ...scope, "target", old.target]);
    }
    if (requested.has("description")) {
      const description = text(requested.get("description"), "description");
      if (description !== (old?.description ?? "")) operations.push(["config", "set", ...scope, "description", description]);
    }
    if (requested.has("modules")) {
      const paths = modules(requested.get("modules"));
      if (JSON.stringify(paths) !== JSON.stringify(old?.modules ?? [])) {
        for (const path of old?.modules ?? []) operations.push(["config", "rm-module", ...scope, path]);
        for (const path of paths) operations.push(["config", "add-module", ...scope, path]);
      }
    }
  }
  return operations;
}

/** Private editor state is separate from the compiler-owned Snapshot. */
export function editorArchivePath(snapshot) {
  if (typeof snapshot !== "string") throw new TypeError("Expected a Snapshot path.");
  return join(dirname(resolve(snapshot)), ".calcit", "editor-state.cirru");
}

const archiveRevisions = new Map();

function checkArchiveDirectory(directory) {
  const info = lstatSync(directory, { throwIfNoEntry: false });
  if (info && !info.isDirectory()) {
    throw new Error("Editor archive requires a real .calcit directory.");
  }
}

function archiveContents(archive) {
  checkArchiveDirectory(dirname(archive));
  const info = lstatSync(archive, { throwIfNoEntry: false });
  if (!info) return null;
  if (!info.isFile()) throw new Error("Editor archive must be a regular file.");
  const fd = openSync(archive, constants.O_RDONLY | constants.O_NOFOLLOW);
  try {
    return readFileSync(fd, "utf8");
  } finally {
    closeSync(fd);
  }
}

function archiveRevision(contents) {
  return contents === null ? null : createHash("sha256").update(contents).digest("hex");
}

/** Load the private archive and record the version this process can replace. */
export function readEditorArchive(snapshot) {
  const archive = editorArchivePath(snapshot);
  const contents = archiveContents(archive);
  archiveRevisions.set(archive, archiveRevision(contents));
  return contents;
}

function archiveConflict(directory, contents) {
  const recovery = join(directory, `editor-state-recovery-${randomUUID()}.cirru`);
  writeFileSync(recovery, contents, { encoding: "utf8", flag: "wx", mode: 0o600 });
  const error = new Error(`Another editor session owns or updated the archive. Pending edits were saved to ${recovery}.`);
  error.name = "EditorArchiveConflict";
  return error;
}

/** Replace the archive only while it still matches the version this process loaded. */
export function writeEditorArchive(snapshot, contents) {
  if (typeof contents !== "string") throw new TypeError("Expected serialized editor state.");
  const archive = editorArchivePath(snapshot);
  const directory = dirname(archive);
  checkArchiveDirectory(directory);
  mkdirSync(directory, { recursive: true, mode: 0o700 });
  checkArchiveDirectory(directory);
  const lock = join(directory, "editor-state.lock");
  let fd;
  try {
    fd = openSync(lock, "wx", 0o600);
  } catch (error) {
    if (error.code === "EEXIST") throw archiveConflict(directory, contents);
    throw error;
  }
  const staging = join(directory, `.editor-state-${randomUUID()}.tmp`);
  try {
    if (archiveRevision(archiveContents(archive)) !== (archiveRevisions.get(archive) ?? null)) {
      throw archiveConflict(directory, contents);
    }
    writeFileSync(staging, contents, { encoding: "utf8", flag: "wx", mode: 0o600 });
    renameSync(staging, archive);
    archiveRevisions.set(archive, archiveRevision(contents));
  } finally {
    closeSync(fd);
    rmSync(lock, { force: true });
    rmSync(staging, { force: true });
  }
}
