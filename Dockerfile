FROM openjdk:8-jre-alpine

# wiremock version and nexus
ARG WIREMOCK_STANDALONE_VERSION=2.17.0
ARG NEXUS=http://central.maven.org/maven2

# set default environment values
ENV WIREMOCK_PORT=8081 JAVA_RUNTIME_ARGUMENTS="-Xmx256m -XX:MaxMetaspaceSize=128m -Xss256k -XX:ParallelGCThreads=2 -XX:CICompilerCount=2"

WORKDIR /usr/local/wiremock-workdir

COPY run_wiremock.sh ./

# download wiremock
RUN mkdir wiremock-root \
  && wget --quiet -O wiremock-standalone.jar ${NEXUS}/com/github/tomakehurst/wiremock-standalone/$WIREMOCK_STANDALONE_VERSION/wiremock-standalone-$WIREMOCK_STANDALONE_VERSION.jar \
  && chmod 755 run_wiremock.sh

EXPOSE $WIREMOCK_PORT

ENTRYPOINT ["/usr/local/wiremock-workdir/run_wiremock.sh"]
CMD ["--no-request-journal", "--root-dir=wiremock-root"]
