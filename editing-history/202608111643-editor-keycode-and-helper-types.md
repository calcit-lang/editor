# 2026-08-11 16:43 editor keycode and helper types

- Added `Number` schemas to all 25 `app.keycode` constants.
- Added a generic `List<T> -> List<T>` schema for `app.util.list/dissoc-idx`.
- Added `String -> String` for the trusted `md5` wrapper and `Bool` schemas for `app.config/cdn?` and `app.config/dev?`.
- Annotated `app.util/now!` with a trusted `unsafe-coerce` at the `Date.now` FFI boundary so the declared `Number` return no longer emits a mismatch warning.
- Unresolved schema-dynamic slots reduced from 413 to 384; remaining preprocessing warnings are primarily untyped map/Struct boundaries and nominal `Option` access.
