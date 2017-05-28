#!/bin/sh

printErr()
{
    printf "%s\n" "$*" >&2;
}

diffDb()
{
    localDb="$1"
    tmpDb="$2"
    path="$trunk/modules/sqlite3-3.16.2"
    $path/sqldiff "$localDb" "$tmpDb"
}

