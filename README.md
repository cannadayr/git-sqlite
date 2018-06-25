## SYNOPSIS
git-sqlite is a collection of shell scripts that allows a sqlite database
to be tracked using the git version control system.

It can be used on an existing database, however, UUIDs will make
multi-master distribution substantially easier.

See src/schema.sql after building the project for an example.

## USAGE GUIDE
create a new database using the git-sqlite example schema:
```
git-sqlite init newdatabase.db
```

attach the database to your repository (has to be done once for each repo):
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

## INSTALLING GIT-SQLITE
Dependencies:
* sqlite3
* sqldiff
* bash
* git
* autotools (build-essential debian repositories)

As of Debian Stretch (release 9), sqldiff is included with the default sqlite3 apt package.

If it is not available for your distribution, see `INSTALLING SQLDIFF` below.

If you are installing from the git src:
```
./reconf
./configure
sudo make install
```

If you are installing from a release, do this:
```
./configure
sudo make install
```

## INSTALLING SQLDIFF

```
wget https://www.sqlite.org/src/tarball/sqlite.tar.gz?r=release
tar xzf sqlite.tar.gz?r=release
cd sqlite
./configure
make sqldiff
sudo install sqldiff /usr/local/bin/
```

See https://www.sqlite.org/download.html for more information

## KNOWN ISSUES
* can't detect diffed triggers and views (should be resolved upstream in sqldiff)
* new columns from alter table dont have explicit types
* merge conflicts don't interleave

## TODOS
* uuid version 1 style
* cleanup diff headers to be closer to what git does
* test cherry-picking

## NOTES
* `git gc` may need to be run periodically
