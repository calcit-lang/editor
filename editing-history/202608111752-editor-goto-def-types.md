# 2026-08-11 17:52 editor goto-def types

- Replaced dynamic `op-data` field reads in `goto-def` with explicit Option unwrapping for text, forced mode, and args.
- Made parsed definition/rule fields (`:key`, `:method`, `:ns`, `:def`) use `get` plus `option:unwrap-or`.
- Normalized target defs and files maps before membership checks and updates, and unwrapped bookmark coordinates before comparison.
- Reduced default-entry preprocessing warnings from 161 to 134.
- Verified the built-in Calcit test command; this snapshot currently has 0 selected tests and 0 executed tests.
