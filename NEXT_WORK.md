# Editor Calcit migration: next work

本批尚未提交；继续迁移后客户端入口的预处理 warning 已从 322 降到 0，仍在使用的外部 `gen-code` 路径也已清零。client/server check 和 page codegen 均已恢复通过。`calcit-test`、`lilac`、`memof` 已废弃，活跃代码已移除这些依赖；后续主要做依赖快照同步与发布前审计，避免一次改动范围过大：

## 1. 先处理依赖模块

- 已在 `/Users/chenyong/repo/calcit-lang/gen-code` 通过 `cr` 结构化迁移 `use-gen-code`、Gemini FFI、`call-genai-msg!`、旧异步 `hint-fn`、动态字段/Option 边界和 trait method key；editor 使用的本机缓存也已同步。
- `gen-code/calcit.cirru --check-only` 已从 36 条 warning 降到 0；其中使用到的 `reel` library 路径已完成类型边界迁移，并将 `memof1-call` 改为 `respo.core/memo-comp-by`。reel 示例入口也已移除 `lilac/memof` 依赖并通过检查。
- editor 的 `yarn compile-page` 已不再打印 gen-code warning；当前 editor 与 gen-code 有效入口均通过预处理检查，`reel` 只保留实际使用的 library 路径检查。
- 外部模块正式发布前仍需确认 `calcit.cirru`、`package.json` 的版本和 lockfile 同步。

## 2. Editor 本地组件进度

- 已完成 `app.comp.watching/comp-watching` 的 router/member 字段 Option 边界迁移。
- 已完成 `app.comp.leaf/comp-leaf`、`on-input`、`on-focus` 的 state/leaf/event 字段迁移。
- 已完成 `app.comp.leaf/on-keydown` 的 selectionStart/selectionEnd FFI 边界收窄。
- 已完成 `app.comp.gen-code-box/use-gen-code-box` 的 states/node 字段迁移。
- 已完成 `app.comp.theme-menu`、`app.comp.picker-notice`、`app.comp.changed-info`、`app.comp.bookmark`、`app.comp.expr`、`app.comp.peek-def`、`app.comp.header`、`app.client`、`app.client-util`、`app.comp.page-editor`、`app.polyfill` 和 `app.theme.star-trail` 的主要字段/FFI 边界迁移。
- 已将 `app.util.shortcuts/on-paste!` 的 clipboard/promise 链收拢到显式 `unsafe-coerce` FFI 边界，并为 `app.comp.page-members/comp-page-members` 补上 `:js-ffi` schema。
- `app.comp.bookmark/comp-bookmark` 的拖拽属性 map 已在传入 Respo 前显式转换为 `respo.schema/DomProps`，相关两条 DOM schema warning 已消失。
- `app.comp.container` 调用 `comp-page-editor` 已改为明确的位置参数，消除了 `:stack`/`:pointer` 两条动态 Struct warning。
- `app.comp.expr/on-keydown`、`app.comp.leaf/on-keydown`、`app.util.shortcuts/on-window-keydown` 的键盘 modifier FFI 字段已显式转换为 `Bool`，消除了 3 条生成式 JsNullish predicate warning。
- 本轮本地组件告警从 136 降到 0；仍在使用的本地代码已统一使用当前 Option/类型边界，并将 `memof1-call-by` 迁移为 `respo.core/memo-comp-by`。editor 的有效入口不再加载 `memof`。

## 3. 当前 editor 本地剩余项

1. 当前没有已确认的 editor、gen-code 或 reel 入口预处理 warning；三者的有效依赖配置均已移除 `lilac/memof`，项目测试统一使用内置 `cr test`。
2. gen-code 的 `check-types` 已可完成；当前剩余 4 个定义、5 个 unresolved dynamic 命中，仅位于 reel/组件参数和异构 map value 边界；插件、AI、状态操作等已改为 `JsObject`、`GenCodeState`、`GenCodeOp` 等明确类型。
3. 外部依赖正式发布前仍需确认 `calcit.cirru`、`package.json` 和 lockfile 是否同步；本批已同步实际使用的 calcit/cache 快照。

## 4. 每批修改的验证方式

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

## 5. 提交前回归

- `git diff --check`
- `yarn compile-server`
- 客户端 check-only；warning 降到 0 后再运行 `yarn compile-page`
- `yarn compile-page` 已通过，生成 `out-page` client bundle。
- `cr calcit.cirru --check-only`、内置 `cr test --summary-only --format json` 已通过；当前没有被发现的测试定义。
- `cr /Users/chenyong/repo/calcit-lang/gen-code/calcit.cirru --check-only`、reel cache `cr calcit.cirru --check-only` 均已通过且无 warning。
- gen-code 已按新快照规范将内容迁移到 `calcit.cirru`，旧 `compact.cirru` 仓库/缓存文件已移除；后续所有命令均显式使用 `calcit.cirru`。
- 使用内置 `cr test`，不恢复 `calcit-test`/`lilac` 依赖
- 更新依赖版本后检查 Yarn lockfile，避免 CI 的 immutable install 因版本漂移失败
