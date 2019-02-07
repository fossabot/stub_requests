#!/usr/bin/env bash

git checkout master
git fetch
stash_created=0

if [[ "$(git diff --stat)" != "" ]]; then
  stash_created=1
  git stash push -u -a -m "Before updating docs"
fi;

git pull --rebase

rake yard

git checkout gh-pages

echo "Cleaning up current documentation"
find . ! -path '*/.git*' ! -path '*/doc*' ! -path '*/update_docs.sh*' ! -path '*/_config.yml*' ! -path '*/_index.html*' ! -path '.' | xargs rm -rf

echo "Copying new documentation"
mv doc/* ./

echo "Sending new documentation to github"
git add --all
git commit -a -m 'Update documentation'
git push --force

if [[ $stash_created == 1 ]]; then
  git stash pop
fi;

git checkout master
