#!/bin/sh

# possible solution for xplatform readlink
# see: https://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac
function readlink() {
  DIR=$(echo "${1%/*}")
  (cd "$DIR" && echo "$(pwd -P)")
}

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
    localDb="$1"
    tmpDb="$2"
    #todo #fixme On Mac OS X I had to use the original SQLite source
    #            instead of the Debian package included as /sqlite3-3.16.2
    #            Let's decide on a unified path: I nominate /sqlite-build.
    #               ~ RM
    if isDarwin; then
        path="$trunk/modules/sqlite-build"
    else
        path="$trunk/modules/sqlite3-3.16.2"
    fi
    $path/sqldiff --transaction "$localDb" "$tmpDb"
}

