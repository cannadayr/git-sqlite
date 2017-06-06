#!/bin/sh

printErr()
{
    printf "%s\n" "$*" >&2;
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
    sqldiff="$1"
    localDb="$2"
    tmpDb="$3"
    noTransaction="$4"

    transactionStr=""
    if [ -n $noTransaction ]; then
        transactionStr="--transaction"
    fi

    $sqldiff $transactionStr "$localDb" "$tmpDb"
}

