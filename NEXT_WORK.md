# Editor Calcit migration: next work

本批已提交到 `codex/upgrade-calcit-toolchain`，客户端入口的预处理 warning 从 322 降到 136；当前仍会因为 warning 被 codegen 阻断。后续按下面顺序继续，避免一次改动范围过大：

## 1. 先处理依赖模块

- `gen-code.core/use-gen-code` 仍有约 13 个字段访问和 JS FFI schema warning。
- `gen-code.core/get-gemini-key!`、`initialize-chat!`、`call-genai-msg!`、`if-let` 也在同一模块中，应在 `/Users/jon.chen/repo/calcit-lang/gen-code` 单独迁移、补测试、发版，再更新 editor 的依赖版本。
- 发布前确认 `calcit.cirru`、`compact.cirru`、`package.json` 的版本和 lockfile 同步。

## 2. 再处理 editor 本地组件

按当前 warning 数量优先：

1. `app.comp.watching/comp-watching`
2. `app.comp.leaf/comp-leaf`、`app.comp.leaf/on-input`、`app.comp.leaf/on-focus`（重点是 DOM selectionStart/selectionEnd 的可空 FFI 访问）
3. `app.comp.gen-code-box/use-gen-code-box`
4. `app.comp.theme-menu/comp-theme-menu`
5. `app.comp.picker-notice/comp-picker-notice`
6. `app.comp.expr/comp-expr`、`app.comp.bookmark/comp-bookmark`、`app.comp.changed-info/comp-changed-info`
7. `app.comp.page-editor/comp-doc`、`app.client`、`app.comp.header` 及剩余小模块。

## 3. 每批修改的验证方式

在使用 `cr tree` 前先执行：

```bash
cr docs agents --full
```

每个小批次都重新统计，而不要复用旧路径：

```bash
cr --entry client calcit.cirru js --check-only > /tmp/editor-client-check.log 2>&1 || true
rg 'Warnings:|Error: "Found|Failure:' /tmp/editor-client-check.log
```

字段迁移时保留 map property 的键。例如 `:value state` 必须改成 `:value $ ...`，不能只替换整个 pair 的 value；事件值通常使用 `option:unwrap-or (get e :value) nil`。对 `get` 返回的 Option 不要直接拿去 `=`、`assoc`、`some?`，应先 unwrap 或使用 `option:some?`。

## 4. 提交前回归

- `git diff --check`
- `yarn compile-server`
- 客户端 check-only；warning 降到 0 后再运行 `yarn compile-page`
- 使用内置 `cr test`，不恢复 `calcit-test`/`lilac` 依赖
- 更新依赖版本后检查 Yarn lockfile，避免 CI 的 immutable install 因版本漂移失败
