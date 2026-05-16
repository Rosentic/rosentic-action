# Rosentic

Catches when changes across branches break each other before merge.

CI tests branches alone. Rosentic tests them together.

**1,250+ scans** across **10 organizations** and **21 repos**.

## Install

Add `.github/workflows/rosentic.yml` to your repo:

```yaml
name: Rosentic Scan
on:
  pull_request:
    branches: [main]

jobs:
  rosentic:
    runs-on: ubuntu-latest
    name: Rosentic - Conflict Detection
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: Rosentic/rosentic-action@v1
```

No signup. No API key. No account.

## What it detects

Three layers of cross-branch conflict detection, all powered by tree-sitter AST analysis across 12 languages.

**L1 — Signature conflicts.** One branch changes a function signature. Another branch still calls the old version. Rosentic catches the mismatch before merge.

**L2 — Route conflicts.** One branch renames or removes an API endpoint. Another branch still calls it. Works across frontend/backend boundaries.

**L3 — Schema conflicts.** One branch drops a protobuf field, GraphQL type, or OpenAPI parameter. Another branch still references it.

Each finding gets a verdict:
- **UNSAFE** — confirmed breaking change with evidence
- **WARNING** — potential conflict, advisory

## What it does NOT do

Rosentic does not catch text merge conflicts. Git already does that. Rosentic catches semantic breaks that Git and CI miss, like when one branch changes a function signature and another branch still calls the old version.

## What you'll see

Rosentic posts inline review comments directly on the PR diff where conflicts occur, plus a summary comment with all findings:

```
⚠ Rosentic — 3 unique finding(s) across 4 branch pairs

  UNSAFE  L1  create_order(customer, items, shipping) — 2 callers still pass 2 args
  UNSAFE  L2  POST /api/order — param shipping_address removed, 1 consumer affected
  WARNING L1  validate_input(data) — 1 advisory caller via reflection
```

When clean: `Rosentic Scan — Clean. No cross-branch conflicts detected.`

## Languages

Go, Python, TypeScript, JavaScript, Java, Kotlin, C#, Rust, Swift, C++, Ruby, PHP.

## Configuration

| Input | Default | Description |
|-------|---------|-------------|
| `mode` | `audit` | `audit` reports conflicts but passes. `enforce` blocks merge. |
| `scan-mode` | `pr` | `pr` checks PR branch vs others. `full` checks all pairs. |
| `stale-days` | `30` | Skip branches with no commits in N days. |
| `format` | `markdown` | Output format: `markdown`, `text`, or `json`. |

## Security

Your code never leaves your environment. The engine runs as a Docker container on GitHub's ephemeral runners. The only data sent externally is scan metadata: timestamp, organization name, repository name, branch count, conflict count, scan duration, and detected agent type. No source code, file paths, or function names are transmitted.

## Links

- [rosentic.com](https://rosentic.com)
- [Documentation](https://rosentic.com/docs)
- [Demo repo](https://github.com/Rosentic/rosentic-demo) with live conflicts
