# 2026-08-11 17:20 editor schema method types

- Added explicit `CirruExpr` and `CirruLeaf` narrowing around trait-method field reads in `app.schema/CirruExprMethods`.
- Updated `app.schema/cirru-compact` to unwrap typed `:text` and `:data` fields instead of relying on dynamic Struct access.
- Reduced default-entry preprocessing warnings from 206 to 198.
- Verified the built-in Calcit test command; this snapshot currently has 0 selected tests and 0 executed tests.
