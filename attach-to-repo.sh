#!/bin/bash
repo="$1"
#sqlite="$2"

# copy sqlite-diff & sqlite-merge
cp sqlite-diff $repo/
cp sqlite-merge $repo/

# modify local .git/config
cd $repo &&
git config diff.sqlite.binary "true"
git config diff.sqlite.command "./sqlite-diff"

git config merge.sqlite.name "sqlite merge"
git config merge.sqlite.driver "./sqlite-merge %O %A %B %L %P"

git config alias.show-sql "show --ext-diff"

# modify local .gitattributes
stringContains()
{
    [ -z "${2##*$1*}" ] && [ -z "$1" -o -n "$2" ]
}

attributes="net.db diff=sqlite merge=sqlite"
touch "$repo/.gitattributes"
if stringContains "$attributes" "$(cat "$repo/.gitattributes")"; then
    # let it pass
    echo
else
    echo "$attributes" >> "$repo/.gitattributes"
fi
