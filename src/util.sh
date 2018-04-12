#!/usr/bin/env bash

printErr()
{
    printf "%s\n" "$*" >&2;
}

stringContains()
{
    [ -z "${2##*$1*}" ] && [ -z "$1" -o -n "$2" ]
}

isAbsPath()
{
    local path="$1"
    local pathStart=${path:0:1}

    if [ "$pathStart" = '/' ]; then
        return 0
    else
        return 1
    fi
}

diffDb()
{
    # NOTE: sqldiff currently can't perform diffs
    # on views or triggers
    # see: https://sqlite.org/sqldiff.html#limitations
    # HOWEVER there might be some paths forward:
    #   we might be able to get around this using
    #   the "--changeset <output file>" option
    #   this seems to detect changes to the sqlite_master tbl
    #   and can be applied using the 'session' extension
    # see: https://sqlite.org/sessionintro.html
    local localDb="$1"
    local tmpDb="$2"
    local noTransaction="$4"

    local transactionStr=""
    if [ -z "$noTransaction" ]; then
        transactionStr="--transaction"
    fi

    # RFM 2018-02-06 adding --primarykey to see if it gets rid of rowid from diff queries
    #                I need rowid on my tables for the triggers, but I don't want them in the diff
    sqldiff --primarykey $transactionStr "$localDb" "$tmpDb"
    #sqldiff $transactionStr "$localDb" "$tmpDb"
}

