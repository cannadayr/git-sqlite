#!/bin/bash
repo="$1" # repo to attach to
db="$2" # relative path to sqlite db inside repo
trunk="$(dirname "$0")"

# if sqldiff or the schema is given as a relative path,
# lets assume its relative inside the repo
sqldiff="$3"
schema="$4"

stringContains()
{
    [ -z "${2##*$1*}" ] && [ -z "$1" -o -n "$2" ]
}

rmTrailingSlash()
{
    echo "$1" | sed 's/\/*$//g'
}

isAbsPath()
{
    path="$1"
    pathStart=${path:0:1}

    if [ "$pathStart" = '/' ]; then
        return 0
    else
        return 1
    fi
}

if [ -z "$repo" ] \
    || [ -z "$db" ] \
    || [ -z "$sqldiff" ]
then
    echo "usage: attach-to-repo.sh <git repo path to attach to> <sqlite database relative path within repo> <path to sqldiff> [<init schema>]" >&2
    echo "if sqldiff or schema is given as a relative path, it is assumed to be inside the git repo" >&2
    exit 1
fi

# rm trailing slash from 'repo' if it has one
repoPath=$(rmTrailingSlash "$repo")

# test if the repo and repo's .git are directories
if [ ! -d "$repoPath" ] \
    || [ ! -d "$repoPath/.git" ]
then
    echo "'$repoPath' isn't a git repository" >&2
    exit 1
fi

# test if we've got sqlite
if ! [ -x "$(command -v sqlite3)" ]; then
    echo 'sqlite is not installed.' >&2
    exit 1
fi

# test if we've got sql-diff

# if sqldiff is given as a relative path,
# lets assume its relative inside the repo
if isAbsPath "$sqldiff"; then
    sqldiffPath="$sqldiff"
    sqldiffTestPath="$sqldiffPath"
else
    sqldiffPath="./$sqldiff"
    sqldiffTestPath="$repoPath/$sqldiff"
fi

if ! [ -x "$sqldiffTestPath" ]; then
    echo 'sqldiff is not found' >&2
    exit 1
fi

# test if the sqlite db is a file
if ! [ -f "$repoPath/$db" ]; then

    echo "'$repoPath/$db' is not a file, attempting to create database with schema" >&2

    # if the schema is given as a relative path,
    # lets assume its relative inside the repo
    if isAbsPath "$schema"; then
        schemaPath="$schema"
        schemaTestPath="$schemaPath"
    else
        schemaPath="./$schema"
        schemaTestPath="$repoPath/$schema"
    fi

    if [ -z "$schema" ] \
        || [ ! -f "$schemaTestPath" ]
    then
        echo "schema is not given or is not a file" >&2
        exit 1
    else
        sqlite3 "$repoPath/$db" < "$schemaPath"
    fi
fi

# test if we've got a sqlite db
if  ! stringContains "SQLite format 3" "$(head -c 15 < "$repoPath/$db")"; then
    echo "'$repoPath/$db' is not sqlite database" >&2
    exit 1
fi

# got through tests, modify repo

# make .git-sqlite dir if it doesn't exist
if [ ! -d "$repoPath/.git-sqlite" ]; then
    mkdir "$repoPath/.git-sqlite"
fi

# copy util, sqlite-diff & sqlite-merge
# if we're not already inside the repo
if [ ! "$trunk" -ef "$repoPath/.git-sqlite" ]; then
    cp "$trunk/util.sh" "$repoPath/.git-sqlite/util.sh"
    cp "$trunk/sqlite-diff" "$repoPath/.git-sqlite/sqlite-diff"
    cp "$trunk/sqlite-merge" "$repoPath/.git-sqlite/sqlite-merge"
fi

# modify local .git/config
cd $repo &&
# add diff section
git config diff.sqlite.binary "true"
git config diff.sqlite.command "./.git-sqlite/sqlite-diff $sqldiffPath"

# add merge section
git config merge.sqlite.name "sqlite merge"
git config merge.sqlite.driver "./.git-sqlite/sqlite-merge $sqldiffPath %O %A %B %L %P"

# add git show-sql alias
git config alias.show-sql "show --ext-diff"

# modify local .gitattributes
attributes="$db diff=sqlite merge=sqlite"

touch "$repo/.gitattributes"
if ! stringContains "$attributes" "$(cat "$repo/.gitattributes")"; then
    echo "$attributes" >> "$repo/.gitattributes"
fi
