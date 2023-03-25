FROM adoptopenjdk/openjdk8:latest AS builder

WORKDIR /workspace


COPY Makefile lei[n] /workspace/

RUN apt-get update \
    && apt-get -y install make wget \
    &&  ([ ! -e lein ] && wget  https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein ) \
    || echo "Cached lein found and used" && \
    chmod +x lein && mv lein /usr/bin/lein 

COPY common-utils /workspace/common-utils
COPY front-end /workspace/front-end
COPY newsfeed /workspace/newsfeed
COPY quotes /workspace/quotes

RUN make libs
RUN make clean all