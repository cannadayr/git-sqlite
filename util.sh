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
    # HOWEVER we might be able to get around this using
    #   sqldiff --tables sqlite_master
    # AND if we add a UUID to the sqlite_master table as a
    # primary key
    localDb="$1"
    tmpDb="$2"
    path="$trunk/modules/sqlite3-3.16.2"
    $path/sqldiff --transaction "$localDb" "$tmpDb"
}

