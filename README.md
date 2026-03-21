# 🌹 Rosentic

**The agent output pipeline. Any agent in. Any repo out.**

Rosentic detects cross-branch compatibility conflicts before they merge. When multiple AI coding agents push changes in parallel, they create invisible breaks between branches that CI pipelines miss. Rosentic catches them.

- AST-level analysis across 11 languages (Python, TypeScript, JavaScript, Go, Ruby, Java, Kotlin, Swift, Rust, C#, C++)
- Cross-language HTTP contract detection (backend routes matched to frontend API calls)
- Runs on your GitHub runners. Your code never leaves your environment.
- Posts a PR comment with a detailed conflict report
- Blocks merge when compatibility conflicts are found

## Quick Start

Add this workflow to your repo at `.github/workflows/rosentic.yml`:

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
      - uses: coachescritique/rosentic-action@v1
```

That's it. 3 lines of config. On every PR, Rosentic scans the PR branch against all active branches and posts the results.

## What It Catches

**Signature mismatches (L1)**
Agent A changes `create_order()` from 2 to 3 parameters. Agent B's branch still calls it with 2. Both branches pass CI individually. Production breaks after merge.

**API contract conflicts (L2)**
Agent A changes a Python backend endpoint to require `shipping_address`. Agent B's TypeScript frontend still sends the old payload. Git merges both cleanly. The app crashes at runtime.

## Example Output

When Rosentic finds conflicts, it posts a PR comment like this:

```
🌹 Rosentic Scan -- 4 conflict(s) found

agent/alice <> agent/bob
Type       | Source                          | Target                        | Detail
SIGNATURE  | backend/main.py:create_order()  | backend/bulk_orders.py L7     | Function requires 3 args, caller sends 2
API CONTRACT | backend/main.py:order_endpoint() | frontend/api.ts:/api/order | Param shipping_address added in source, missing in target
```

When no conflicts are found:

```
🌹 Rosentic Scan -- Clean

No cross-branch conflicts detected.
```

## Configuration

| Input | Default | Description |
|-------|---------|-------------|
| `scan-mode` | `pr` | `pr` checks the PR branch against all others. `full` checks all pairs. |
| `format` | `markdown` | Output format: `markdown`, `text`, or `json` |
| `stale-days` | `30` | Skip branches with no commits in N days. `0` to scan all. |
| `block-on-conflict` | `true` | Exit with failure to block merge when conflicts found |

## Supported Languages

Python, TypeScript, JavaScript, Go, Ruby, Java, Kotlin, Swift, Rust, C#, C++

Cross-language detection currently supports HTTP route matching: Python (FastAPI, Flask) backend routes matched to TypeScript/JavaScript fetch and axios calls.

## How It Works

1. PR is opened on your repo
2. GitHub Action triggers and pulls the Rosentic Docker image
3. Engine parses all active branches using tree-sitter AST analysis
4. Checks the PR branch against every other branch for compatibility conflicts
5. Posts a PR comment with the conflict report
6. Blocks or approves merge based on results
7. Runner is destroyed. Your code never left GitHub's infrastructure.

## Security

- The engine runs as a Docker container on GitHub's ephemeral runners
- Your source code is never transmitted to or stored on Rosentic's servers
- The license key gates access to the Docker image, nothing else
- No telemetry on your code. No data collection. No phone home.

## Get a License Key

Visit [rosentic.com](https://rosentic.com) to request early access.

## Links

- [Website](https://rosentic.com)
- [How It Works](https://rosentic.com/how-it-works)
- [Pricing](https://rosentic.com/pricing)
- [Documentation](https://rosentic.com/docs)

---

🌹 Rosentic -- The agent output pipeline
