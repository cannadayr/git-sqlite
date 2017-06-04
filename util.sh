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
    #printErr $sqldiff
    localDb="$2"
    tmpDb="$3"
    #todo #fixme On Mac OS X I had to use the original SQLite source
    #            instead of the Debian package included as /sqlite3-3.16.2
    #            Let's decide on a unified path: I nominate /sqlite-build.
    #               ~ RM
    #if isDarwin; then
    #    path="$trunk/modules/sqlite-build"
    #else
    #    path="$trunk/modules/sqlite3-3.16.2"
    #fi
    $sqldiff --transaction "$localDb" "$tmpDb"
}

