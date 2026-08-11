# Synchronize the Calcit procs lockfile

- `package.json` already required `@calcit/procs` `^0.13.10`, while the workspace dependency entry in `yarn.lock` still declared `^0.13.8`.
- Refreshed the lockfile with `yarn install --mode=update-lockfile`.
- Confirmed the exact CI guard passes locally with `yarn install --immutable`.
