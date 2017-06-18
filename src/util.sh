#!/bin/sh

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
    path="$1"
    pathStart=${path:0:1}

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
    localDb="$1"
    tmpDb="$2"
    noTransaction="$4"

    transactionStr=""
    if [ -z "$noTransaction" ]; then
        transactionStr="--transaction"
    fi

    sqldiff $transactionStr "$localDb" "$tmpDb"
}

