AC_INIT([git-db], [alpha], []@local.net)
AM_INIT_AUTOMAKE([foreign])

## check for bash
AC_CHECK_PROG(bash,[bash],[bash],[no])
test "$bash" == "no" && AC_MSG_ERROR([Required program 'bash' not found.])

## check for sqldiff
AC_CHECK_PROG(sqldiff,[sqldiff],[sqldiff],[no])
test "$sqldiff" == "no" && AC_MSG_ERROR([Required program 'sqldiff' not found.])

summary="A tool for tracking sqlite3 databases with git"
AC_SUBST([summary])

## include src files
AC_CONFIG_FILES([Makefile
                 git-db:git-db.in])
AC_OUTPUT
