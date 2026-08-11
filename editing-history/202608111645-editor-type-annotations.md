# 2026-08-11 16:45 editor type annotations

- Added explicit Calcit schemas for small, stable helpers in `app.util`, `app.client-util`, `app.comp.about`, and `app.util.stack`.
- Added `Number`, `Bool`, `String`, qualified enum/struct types, and a generic list predicate contract.
- Reduced unresolved schema-dynamic slots from 421 to 413 while preserving dynamic boundaries for AST/map/FFI code.
- Project preprocessing remains warning-only; the next batch should address the remaining unknown map and trait-receiver boundaries.
