AC_INIT([git-sqlite], [alpha], [cannadayr]@gmail.com)
AM_INIT_AUTOMAKE([foreign])

# check for bash
AC_CHECK_PROG(bash,[bash],[bash],[no])
test "$bash" == "no" && AC_MSG_ERROR([Required program 'bash' not found.])

# check for sqldiff
AC_CHECK_PROG(sqldiff,[sqldiff],[sqldiff],[no])
test "$sqldiff" == "no" && AC_MSG_ERROR([Required program 'sqldiff' not found.])

# check for git
AC_CHECK_PROG(git,[git],[git],[no])
test "$git" == "no" && AC_MSG_ERROR([Required program 'git' not found.])

# set summary
summary="A tool for tracking sqlite3 databases with git"
AC_SUBST([summary])

# include src files
AC_CONFIG_FILES([Makefile
                 git-sqlite:git-sqlite.in])
AC_OUTPUT
