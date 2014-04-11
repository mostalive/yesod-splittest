# Dockerfile for starting yesod-splittest in development mode
# this assumes that there is a haskell/dev:rundev box which exists
# and contains a fully built yesod-splittest application
# also assumes there is some container running pg that is linked to this 
# container so that we can extract the linked interface


FROM haskell/dev:rundev
MAINTAINER arnaud.oqube@gmail.com

# work from curry user account
USER curry
ENV HOME  /home/curry

# move to app
WORKDIR /home/curry/yesod-splittest

# expose one port for web application
EXPOSE 3000

# start yesod application in development, using environment provided PG 
# connections info
CMD sed -i -e "s/host: localhost/host: ${PG_PORT_5432_TCP_ADDR}/g" \
           -e "s/port: 5432/port: ${PG_PORT_5432_TCP_PORT}/g" \
           config/postgresql.yml &&\
    cat config/postgresql.yml &&\
    dist/build/yesod-split-testing/yesod-split-testing Development  