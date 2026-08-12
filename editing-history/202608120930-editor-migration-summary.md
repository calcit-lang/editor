# 2026-08-12 editor Calcit migration summary

本 PR 完成 editor 从旧 Calcit 写法到 0.13 类型边界的主体迁移，并同步依赖快照。

- 为 keycode、AST、writer、IR、server/client 状态和 DOM/FFI 边界补充 schema、`get`、`option:unwrap-or`、`option:some?` 与必要的 `assert-type`。
- 默认入口 warning 从 378 降到 0；client 入口的大批 warning 已清理，剩余边界已留在后续 issue/模块迁移中。
- 移除已废弃的 `lilac` 配置依赖，继续使用 Calcit 内置 `cr test`，不恢复 `calcit-test` 或 `memof`。
- 修复 `@calcit/procs` lockfile 漂移，并将 `calcit-lang/gen-code` 从 moving `main` 固定到已发布的 `0.0.7` tag；gen-code 0.0.7 已通过独立 release PR 发布。
- 验证过 `caps`、`yarn install --immutable`、`yarn compile-server` 和 editor 的 check-only 入口。

后续工作集中在 gen-code/DOM FFI 的少量动态边界和 client warning 收尾，不再通过额外的逐文件历史文档记录。
