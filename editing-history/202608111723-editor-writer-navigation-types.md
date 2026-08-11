# 2026-08-11 17:23 editor writer navigation types

- Added explicit Option unwrapping for writer navigation bookmarks, pointers, stacks, and operation flags.
- Narrowed CirruExpr data reads in `go-down`, `go-left`, and `go-right`.
- Made `move-order` operate on an unwrapped writer map and typed its source/target indexes.
- Reduced default-entry preprocessing warnings from 198 to 180.
- Verified the built-in Calcit test command; this snapshot currently has 0 selected tests and 0 executed tests.
