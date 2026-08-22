# Calcit project reference

This repository uses the current Calcit CLI and the canonical `calcit.cirru` snapshot.

For current syntax, editing, query, upgrade, and static-analysis instructions, run:

```bash
calcit docs agents --full
calcit docs read upgrade --full
calcit docs read edit-tree.md --full
calcit docs read static-analysis.md --full
```

Typical project checks:

```bash
calcit calcit.cirru edit format
calcit calcit.cirru --check-only
calcit calcit.cirru --entry client --check-only
calcit calcit.cirru js
```

Use `calcit`, not the retired `cr` command. Do not copy the full language reference into this project; the installed CLI documentation is the source of truth.

