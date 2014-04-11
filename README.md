=======
yesod-splittest
===============

Space for various experiments with Yesod, a/b split-testing, javascript
widgets, multi-tenancy.


This repository is a work in progress, a first
[Yesod](http://www.yesodweb.com) application. We want to explore a type
safe way of building web applications to see if we can build web
applications faster in the short as well as the long term.

This works with ghc version 7.6.3 . Check with ghc --version if you have
the correct one. Otherwise, we found [these instructions to install cabal and
ghc](http://lenguyenthedat.blogspot.co.uk/2013/12/haskell-ghc-cabal-and-all-that-jazz.html)
helpful for ubuntu 12.04 .

Also check your cabal version, and if the path is set correctly. E.g.

```bash
> which cabal
/home/willem/.cabal/bin/cabal

> cabal --version

cabal-install version 1.18.0.3
using version 1.18.1.3 of the Cabal library
```

Some postgres magic from this post about [installing Yesod with postgres
and
fay](http://www.hoppinger.com/blog/haskell-in-the-browser-setting-up-yesod-and-fay)

Was useful. Modifying pg_hba.conf so we can actually access a database
is something that is easy to forget. Do not forget to restart
postgres after changing the config files. I found it ore reliable to just log in to psql, the postgres command line and create the user (users are called roles in postgres) and database from there. See below for details.

```
service postgresql restart
```

Create the role and database through postgres. If you need more, read [how to use roles and manage grant permissions in postgres](https://www.digitalocean.com/community/articles/how-to-use-roles-and-manage-grant-permissions-in-postgresql-on-a-vps--2)

'''bash
> sudo -u postgres psql
postgres# create role splittest password 'splittest' with login;
postgres# create database splittest owner splittest;
'''

You can exit the psql shell by pressing ctrl-D.

This should give the user splittest access to the database. Test it with:

'''bash

'''

We alsoo can grant access to the database
through the postgresql prompt and re-set the password through the prompt
as well. We chose not to have dashes in the database name, as that forces
escaping all the time.

In case of doubt, use the help command, e.g.

'''bash
  \help create
  ... command syntax
  \help create database
'''

```
postgres=# grant all privileges on database splittest to splittest;
GRANT
postgres=# \list
                                   List of databases
   Name    |   Owner   | Encoding |   Collate   |    Ctype    |
Access privileges
-----------+-----------+----------+-------------+-------------+-------------------------
 postgres  | postgres  | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 splittest | splittest | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/splittest          +
           |           |          |             |             | splittest=CTc/splittest
 template0 | postgres  | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres            +
           |           |          |             |             | postgres=CTc/postgres
 template1 | postgres  | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres            +
           |           |          |             |             |
postgres=CTc/postgres
(4 rows)

root@haskell_dev:~# sudo -u postgres psql
could not change directory to "/root"
psql (9.1.13)
Type "help" for help.

root@haskell_dev:~# psql -U splittest -d splittest
Password for user splittest:
psql: FATAL:  password authentication failed for user "splittest"
root@haskell_dev:~# sudo -u postgres psql
could not change directory to "/root"
psql (9.1.13)
Type "help" for help.

postgres=# alter role splittest with password 'splittest';
```

Note the display after the \list command should mention the splittest
user in the rightmost column.


You need a bit of extra magic to let the [Fay javascript
compiler](https://github.com/faylang/fay/wiki) do
its' work. Specify the location of your package sandbox in an
environment variable:

```bash
export HASKELL_PACKAGE_SANDBOX=.cabal-sandbox/x86_64-linux-ghc-7.6.3-packages.conf.d/
```

The exact path depends on your operating system and compiler version.

We work in a sandbox.

```bash
cabal sandbox init
cabal install --only-dependencies
cabal build
```
