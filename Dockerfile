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

FROM adoptopenjdk/openjdk8:latest AS assessment-front-end

WORKDIR /app
COPY --from=builder /workspace/build/front-end.jar ./

ENV APP_PORT=8080
EXPOSE 8080

#TODO: refactor when deploying
ENV STATIC_URL=http://localhost:8000
ENV QUOTE_SERVICE_URL=http://localhost:8081
ENV NEWSFEED_SERVICE_URL=http://localhost:8082
ENV NEWSFEED_SERVICE_TOKEN='T1&eWbYXNWG1w1^YGKDPxAWJ@^et^&kX'

CMD ["java", "-jar", "front-end.jar"]  

FROM adoptopenjdk/openjdk8:latest AS assessment-quotes

WORKDIR /app
COPY --from=builder /workspace/build/quotes.jar ./

ENV APP_PORT=8081
EXPOSE 8081

CMD ["java", "-jar", "quotes.jar"]  

FROM adoptopenjdk/openjdk8:latest AS assessment-newsfeed

WORKDIR /app
COPY --from=builder /workspace/build/newsfeed.jar ./

ENV APP_PORT=8082
EXPOSE 8082

CMD ["java", "-jar", "newsfeed.jar"]  