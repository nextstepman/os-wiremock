Wiremock for Openshift. Permissions are setup so that it will run with an arbitrary user, 
as required by most Openshift installations. 

Also includes some convenience to set java runtime properties.

# Supported tags and respective `Dockerfile` links

-	[`latest`](https://github.com/nextstepman/os-wiremock/blob/master/Dockerfile): contains latest openjdk:8-jre-alpine and the (currently) latest wiremock version, which as of now is 2.17.0

# Usage

## Quick start

One intended use of this image is to either have your own Dockerfile and copy the wiremock config files:
Example:

```
FROM nextstepman/os-wiremock:latest
COPY src/test/resources/wiremock /opt/wiremock/wiremock-root
```

Next, you can use that in a docker-compose file to have your mock integrated:

```
version: '3'
services:
  my-mock:
    build:
      context: .
      dockerfile: path-to-my-mock/Dockerfile
    image: my-mock-docker
    ports:
      - "8081:8081"
...

```

Otherwise, you can also directly start the docker container and mount a volume with the wiremock files:

```
docker run -it --rm -v `pwd`/src/test/resources/wiremock:/opt/wiremock/wiremock-root -p 81:8081 nextstepman/os-wiremock:latest
```

## Open ports

The following ports are opened by default:

 - 8081 - HTTP listener

## Default Settings

### Permissions

Wiremock runs in folder `/opt/wiremock` which is owned by user `wiremock:root` and has mode 0775, 
so that the default user in Openshift will be able to write to that directory in case you need that, e.g. to record.
 
### Java Runtime Settings

The image uses 1 environment variable to set default java runtime parameters:

* `JAVA_RUNTIME_ARGUMENTS`: sets basic java memory settings as well as a default heap of 256 MB

These will be applied in the run_wiremock.sh shell script which is set as entrypoint. See that file for details

### Deployment

Either use the default configured `CMD` which is `--no-request-journal --root-dir=wiremock-root` and put your wiremock definition files to the folder `wiremock-root`
or specify your own startup commands. 

The `--no-request-journal` is beneficial if you intend to deploy that wiremock to Openshift, as it inhibits the in-memory journal which would fill up your avalable memory quickly.
