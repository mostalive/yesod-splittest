#!/bin/sh
# configure ghc and cabal stuff
# should be run as user to be configured

PROXY=$1

if [ ! -z $PROXY ]; then
    export http_proxy=$PROXY
    export https_proxy=$PROXY
fi


cabal update
cabal install cabal-install

echo "export PATH=\$HOME/.cabal/bin:\$PATH" >> ~/.bashrc

. ~/.bashrc

cabal install hlint ghc-mod stylish-haskell hdevtools ghci-ng
