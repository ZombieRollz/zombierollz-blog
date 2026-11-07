#!/bin/bash
set -e

cd ~/quartz || exit 1

echo "Building Quartz..."
npx quartz build

echo "Staging changes..."
git add content

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

echo "Committing..."
git commit -m "Update notes"

echo "Pushing..."
git push origin v5

echo "Done."
