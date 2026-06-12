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
| `active-only` | `true` | Only scan branches with open PRs (live siblings). Set `false` for full repo-wide debt sweeps. |
| `stale-days` | `30` | Skip branches with no commits in N days. Applied when `active-only` is `false`. |
| `format` | `markdown` | Output format: `markdown`, `text`, or `json`. |

### Why active-only is the default

Without `active-only`, every scan compares your PR against all remote branches - including abandoned experiments and stale feature branches nobody plans to merge. The result: real conflicts between live work get drowned in debt-vs-debt noise.

With `active-only: true`, Rosentic queries the GitHub API for branches with open PRs and scans only those. Your PR is checked against work that is actually heading toward merge, not against branches from three months ago.

To run a full repo-wide sweep (nightly debt audits, etc.), set `active-only: false`:

```yaml
- uses: Rosentic/rosentic-action@v1
  with:
    active-only: 'false'
```

If the GitHub API call fails (restricted token permissions), Rosentic falls back to all-branches automatically and logs a warning. The scan never fails over scoping.

## Security

The engine runs as a Docker container on GitHub's ephemeral runners. Without an API key, source code does not leave the runner and only aggregate scan metadata is sent externally.

When a Rosentic API key is configured, scan evidence is uploaded to the Rosentic dashboard. That evidence includes metadata such as file paths, function names, route paths, schema fields, lifecycle status, and branch attribution. Source file contents and raw diffs are not uploaded.

See `docs/data-egress.md` in the Rosentic engine repository for the full mode-by-mode data egress description.

## Links

- [rosentic.com](https://rosentic.com)
- [Documentation](https://rosentic.com/docs)
- [Demo repo](https://github.com/Rosentic/rosentic-demo) with live conflicts
