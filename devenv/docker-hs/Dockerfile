# Dockerfile for setting up a working haskell development environment
#

FROM stackbrew/ubuntu:saucy
MAINTAINER arnaud.oqube@gmail.com

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y build-essential haskell-platform libncurses-dev libpq-dev git
RUN locale-gen en_US.UTF-8

# create dedicated user for dev
RUN useradd -m -s /bin/bash curry
RUN chown -R curry /home/curry

# install cabal stuff as user curry
USER curry
ENV HOME  /home/curry

RUN cabal update
RUN cabal install cabal-install

RUN echo "export PATH=\$HOME/.cabal/bin:\$PATH" >> ~/.bashrc

WORKDIR /home/curry

# expose one port for web application
EXPOSE 3000