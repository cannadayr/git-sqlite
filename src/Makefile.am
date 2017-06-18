# scripts to install
bin_SCRIPTS = \
    git-sqlite \
    git-sqlite-diff \
	git-sqlite-diff-parse \
    git-sqlite-merge

# files to install in /usr/local/share/PACKAGE/
utildir = $(datadir)/git-sqlite

utilities = \
	util.sh \
	schema.sql

dist_util_DATA = $(utilities)
EXTRA_DIST = $(utilities)

# clean files
CLEANFILES = $(bin_SCRIPTS)
