# 2026-08-11 19:55 editor Date.now call type cleanup

- Corrected `app.util/now!` to invoke `js/Date.now` before `unsafe-coerce`, matching the FFI call shape used elsewhere.
- Reduced preprocessing warnings from 8 to 7.
- Built-in `cr test --summary-only --format json` selected and executed 0 tests in this project.
