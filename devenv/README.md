Development Environment
=======================

This directory contains tools that can help alleviate the pain of setting up a proper development environment for working on Fay,
Yesod, PostgresSQL and all that stuff...

There you can find:

* A [Vagrantfile](http://vagrantup.com) for firing up a VM containing a complete and hopefully correctly configured Haskell
development environment.

## Development VM

The Development VM is available as a `Vagranfile`. To use it:
* Install [vagrant](http://vagrantup.com)
* Install [Virtualbox](http://www.virtualbox.org)
* Run vagrant in this directory to build the machine:
 
        > vagrant up

* Go and take a looooong coffee
* Log into the new VM and fire up emacs

        > vagrant ssh
        > emacs -nw

You should end up having a box providing the following:

* A base Ubuntu 13.10 box (would need some trimming...)
* Latest [haskell-platform](http://www.haskell.org/platform/) which, at times of this writing, includes GHC 7.6.3
* Latest [emacs](https://www.gnu.org/software/emacs) 24 operating system
* Latest [cabal](http://www.haskell.org/haskellwiki/Cabal) updated from hackage (should be at least version 1.18.0.3 to
support sandboxes)
* A number of code development support tools: [ghc-mod](http://www.mew.org/~kazu/proj/ghc-mod/en/),
[hdevtools](https://github.com/bitc/hdevtools/), [hlint](http://community.haskell.org/~ndm/hlint/),
[sytlish-haskell](https://github.com/jaspervdj/stylish-haskell)
* Pre-packaged emacs configuration to provide some comfortable Haskell hacking experience thanks to some great packages
  developed by smart people: Code completion, code formatting, automatic syntax checking...

The upside of having all this inside a VM is that you can mess up your cabal installation at will!

## Deployment containers

The various `docker-xxx` directories provide containers for [docker](http://docs.docker.io/) to run the components of a yseod/fay
based web application.

### Howto

* Install [docker](http://docs.docker.io/) for your platform and start it
* Build the postgresql container, giving the produced image a name for future reference:

        > docker build -t haskell/pg docker-pg

* Run this container, exposing the postgresql port and naming it for easy linking between containers

        > docker run -d --name pg -P haskell/pg

* Build the haskell dev environment container and build the soft (this could probably be automated...):

        > docker build -t haskell/dev docker-hs
        > docker run -t -i haskell/hs bash
        > git clone https://github.com/mostalive/yesod-splittest
        > cd yesod-splittest
        > cabal install --only-dependencies
        # go and take another coffee...
        > cabal build
        # more coffee...
        > exit

* This yields a docker image containing bleeding edge build for *yesod-splittest*  project (or any other project for that
  matter...). Now, you can commit this image and use the last Dockerfile to turn this into a runnable container:

        > docker ps -a
        # note the container id of the haskell/dev:latest image
        > docker commit <container id>  haskell/dev:rundev
        > docker build --no-cache -t haskell/dev:run docker-run/
        # no coffee this time...

* And finally run the newly built yesod application into the container:

        > docker run -d --link pg:pg -P haskell/dev:run

To check that everything is fine, run `docker ps`, you should see (at least) two running containers along with the TCP ports
mapping they are using:

    CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                     NAMES
    3c2893a51ed5        haskell/dev:run     "/bin/sh -c 'sed -i    21 minutes ago      Up 5 seconds        0.0.0.0:49176->3000/tcp sick_wright                                                                                                                                                                                                                                                                                                                                                 14b238f1269c        haskell/pg:latest   /usr/lib/postgresql/   27 hours ago        Up 5 minutes        0.0.0.0:49154->5432/tcp   sick_wright/pg


* You can now point your browser to `http://localhost:49176` (or whichever port the haskell/dev:run container is mapped to) to
  access the application.

