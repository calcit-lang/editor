# 2026-08-11 19:25 editor IR Struct path cleanup

- Restored the complete `swap-left` update chain while keeping expression data updates at the Struct boundary.
- Replaced clone/indent/rename `assoc-in` traversals through Struct fields with explicit `update`/map operations.
- Narrowed rename pointer and leaf text lookups with explicit Option defaults.
- Reduced preprocessing warnings from 11 to 9.
- Built-in `cr test --summary-only --format json` selected and executed 0 tests in this project.
