ld with
#  docker build -t 'alanz/haskell-ghc-7.8-64' .

FROM ubuntu:14.04
#FROM debian:testing

MAINTAINER alan.zimm@gmail.com

ENV DEBIAN_FRONTEND noninteractive

######### make sure base image is current ##############################

RUN echo "1" && apt-get update

RUN echo "1" && apt-get -y dist-upgrade


####### GHC 7.8.3 offical ######################

RUN apt-get -y install wget
RUN wget http://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2
RUN apt-get install -y build-essential libncurses-dev libpq-dev libgmp-dev git
RUN locale-gen en_US.UTF-8


RUN tar xvfj ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2
RUN cd ghc-7.8.3 && ./configure
RUN cd ghc-7.8.3 && make install

# Clean up
RUN rm -fr ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2 ghc-7.8.3

RUN ghc --version

######### cabal-install ################################################

#RUN echo "1" && apt-get update
#RUN echo "2" && apt-get update
RUN echo "3" && apt-get update

RUN apt-get -y install zlib1g-dev wget

RUN wget http://www.haskell.org/cabal/release/cabal-install-1.20.0.2/cabal-install-1.20.0.2.tar.gz
RUN tar xvfz cabal-install-1.20.0.2.tar.gz
RUN (cd cabal-install-1.20.0.2 && ./bootstrap.sh)
RUN rm -fr cabal-install-1.20.0.2*
RUN [ ! -f /.bashrc ] && echo export PATH=/.cabal/bin:$PATH > /.bashrc
ADD config /.cabal/config
RUN /.cabal/bin/cabal update
RUN /.cabal/bin/cabal install cabal-install
RUN /.cabal/bin/cabal update
RUN /.cabal/bin/cabal install alex happy yesod-bin
CMD ["/bin/bash"]
