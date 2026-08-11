# 2026-08-11 20:13 editor client warning cleanup

- Migrated another batch of client components from required struct field syntax to explicit `get` plus `option:unwrap-or`.
- Covered draft box, abstract modal, search, leaf keyboard handling, dependency graph, page files, namespace list, and replace-name modal.
- Preserved map property pairs such as `:value state` while unwrapping event values.
- Replaced nullable DOM predicates with `js-present?` where the compiler can narrow the FFI value.
- Client preprocessing warnings decreased from 322 to 136. Remaining work is documented in `NEXT_WORK.md`, with `gen-code` listed as the next dependency to migrate and release.
