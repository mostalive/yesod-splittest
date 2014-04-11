#!/bin/sh
# install needed system tools

PROXY=$1

export http_proxy=$PROXY
export https_proxy=$PROXY

apt-get update
apt-get install -y build-essential haskell-platform 
# needed by terminfo <- ghci-ng
apt-get install -y libncurses-dev

apt-get install -y git emacs24

locale-gen en_US.UTF-8

