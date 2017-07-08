1 MINUTE USAGE GUIDE
====================
create a new database using the git-sqlite example schema:
```
git-sqlite init newdatabase.db
```

attach the database to your repository:
```
git-sqlite attach newdatabase.db
```

show a diff using the git-sqlite diff driver:
```
git show-sql <COMMIT SHA>
```

resolve a merge conflict (after manually editing the merge_file)
```
git apply-sql
```

INSTALLING GIT-SQLITE
=====================
Dependencies:
    - sqlite3
    - sqldiff
    - bash
    - git

sqldiff is included in the sqlite source code,
it needs to be compiled from the sqlite source code,
and installed in the user path.

A basic example is below, see `INSTALLING SQLDIFF`

If you are installing from the git src, do the following:
```
./bootstrap
./configure
sudo make install
```

If you are installing from a release, do this:
```
./configure
sudo make install
```

INSTALLING SQLDIFF
==================

```
wget https://www.sqlite.org/src/tarball/sqlite.tar.gz?r=release
tar xzf sqlite.tar.gz?r=release
cd sqlite
./configure
make sqldiff
sudo install sqldiff /usr/local/bin/
```

See https://www.sqlite.org/download.html for more information

ISSUES
======
    - detecting diffed triggers & views (maybe should be handled in sqldiff upstream)
    - new columns from alter table dont have explicit types
    - uuid version 1 style

