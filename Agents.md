# Agent notes

This is the Calcit editor application. Keep project notes short and use the maintained Calcit/Respo documentation for language and framework details.

## Before editing

```bash
calcit docs agents --full
calcit docs read upgrade --full
calcit query config
calcit query ns
calcit query modules
```

The only source snapshot is `calcit.cirru`. Use `calcit edit` / `calcit tree`, never add `compact.cirru`; format after structural changes.

## Validation

```bash
caps --ci
calcit calcit.cirru edit format
git diff --exit-code -- calcit.cirru
calcit calcit.cirru --check-only
calcit calcit.cirru --entry client --check-only
calcit calcit.cirru js
yarn install --immutable
```

For framework APIs, query the installed module documentation with `calcit docs read` or `calcit libs readme`; do not maintain a copied language manual in this repository. Project-specific entry behavior and build scripts remain in `package.json` and the workflow.
