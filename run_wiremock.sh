#!/bin/sh
exec java $JAVA_RUNTIME_ARGUMENTS -jar wiremock-standalone.jar --port=$WIREMOCK_PORT $*
