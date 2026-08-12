# 2026-08-12 editor gen-code tag dependency

- Checked the remote `calcit-lang/gen-code` tags; `0.0.6` is the newest published tag.
- Changed `deps.cirru` from the moving `main` branch to the immutable `0.0.6` tag.
- Ran `caps status`/`caps` and confirmed the local module is checked out at tag `0.0.6`.
- `yarn install --immutable` and `yarn compile-server` pass. The tagged gen-code snapshot still reports its existing 36 preprocessing warnings; those remain tracked for a separate gen-code migration/release.
