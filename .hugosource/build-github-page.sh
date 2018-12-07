#!/bin/bash
#
# build hugo site and sync to github
#

HUGO_SOURCE_DIR=".hugosource"
REPO_ROOT="$(git rev-parse --show-toplevel)"

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# delete old public dir
test -d "${REPO_ROOT}/${HUGO_SOURCE_DIR}/public/" && rm -r "${REPO_ROOT}/${HUGO_SOURCE_DIR}/public/"

# Build the page
hugo

# rsync to github page dir (repo root)
rsync -av --delete --exclude=.hugosource --exclude=.git --exclude=.github --exclude=charts "${REPO_ROOT}/${HUGO_SOURCE_DIR}/public/" "${REPO_ROOT}"

# Add changes to git.
git add --all .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
