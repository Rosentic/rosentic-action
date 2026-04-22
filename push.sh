#!/bin/bash
echo "Pushing main..."
git push origin main
echo "Updating v1 tag..."
git tag -f v1 main
git push origin v1 --force
echo "Done. v1 tag now points to $(git rev-parse --short v1)"
