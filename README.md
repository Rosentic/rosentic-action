# Rosentic

Catches when changes across branches break each other before merge.

CI tests branches alone. Rosentic tests them together.

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

## What it does

- **Parses every active branch** using tree-sitter AST analysis across 11 languages
- **Detects breaking changes** — function signature mismatches, API contract conflicts, schema divergence
- **Posts a PR comment** showing exactly which branches conflict and why

## What you'll see

When conflicts exist:

```
Rosentic Scan - 4 conflict(s) found

agent/alice <> agent/bob
Type           | Source                           | Target                     | Detail
SIGNATURE      | backend/main.py:create_order()   | backend/bulk_orders.py L7  | Requires 3 args, caller sends 2
API CONTRACT   | backend/main.py:order_endpoint() | frontend/api.ts:/api/order | Param shipping_address missing
```

When clean: `Rosentic Scan - Clean. No cross-branch conflicts detected.`

## Configuration

| Input | Default | Description |
|-------|---------|-------------|
| `mode` | `audit` | `audit` reports conflicts but passes. `enforce` blocks merge. |
| `scan-mode` | `pr` | `pr` checks PR branch vs others. `full` checks all pairs. |
| `stale-days` | `30` | Skip branches with no commits in N days. |

## Security

Your code never leaves your environment. The engine runs as a Docker container on GitHub's ephemeral runners. No telemetry. No data collection.

## Links

- [rosentic.com](https://rosentic.com)
- [Documentation](https://rosentic.com/docs)
- [Demo repo](https://github.com/Rosentic/rosentic-demo) with live conflicts
