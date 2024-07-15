#!/usr/bin/env bash
set -x -e

UPSTREAM_REPO=$1
TARGET_BRANCH=$2

OWNER_REPO=`git remote -v | grep -w origin | head -n 1 | grep -Po 'git@github\.com:\K.+?(?=\.git)'`

git remote -v | grep -w upstream || git remote add upstream git@github.com:${UPSTREAM_REPO}.git

LATEST=`gh release list -L 1 -R ${UPSTREAM_REPO} --json tagName -t '{{range .}}{{.tagName}}{{end}}'`
LOCAL_LATEST=`git tag -l --sort=-v:refname | head -n 1 | xargs`
RELEASE_URL="https://github.com/${UPSTREAM_REPO}/releases/tag/${LATEST}"
if [ $LATEST != $LOCAL_LATEST ]; then
    BRANCH_NAME="chore/sync-$LATEST"
    git fetch upstream refs/tags/$LATEST:refs/tags/$LATEST
    git branch -D chore/sync-$LATEST 2&>/dev/null || true
    git switch -c chore/sync-$LATEST $LATEST
    git push -u origin chore/sync-$LATEST
    gh pr create -B $TARGET_BRANCH -t "Sync $LATEST" -b $RELEASE_URL -R $OWNER_REPO
fi
