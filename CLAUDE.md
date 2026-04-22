# CLAUDE.md

## Push rules

After ANY commit to this repo, always run:

```
git push origin main
git tag -f v1 main
git push origin v1 --force
```

Never push main without also updating the v1 tag. The v1 tag must always point to the latest commit on main. Users install @v1 and will get stale code if the tag is behind.

## Docker namespace

The Docker image is at ghcr.io/rosentic/rosentic-engine:latest. Never reference coachescritique anywhere in this repo.
