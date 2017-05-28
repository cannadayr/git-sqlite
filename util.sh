#!/bin/sh

printErr()
{
    printf "%s\n" "$*" >&2;
}

diffDb()
{
    current="$1"
    checked_in="$2"
    path="$trunk/modules/sqlite3-3.16.2"
    $path/sqldiff "$current" "$checked_in"
}

