#!/bin/bash
#
# build hugo site and sync to github
#

REPO_ROOT="$(git rev-parse --show-toplevel)"


echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# rsync
rsync -av --delete --exclude=.hugosource --exclude=.git --exclude=.github "${REPO_ROOT}/public/" "${REPO_ROOT}"

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
