# 2026-08-11 17:56 editor cp/mv namespace types

- Added explicit Option unwrapping for source and target namespace fields in `cp-ns` and `mv-ns`.
- Unwrapped files-map lookups before passing copied entries to `assoc`.
- Reduced default-entry preprocessing warnings from 116 to 106.
- Verified the built-in Calcit test command; this snapshot currently has 0 selected tests and 0 executed tests.
