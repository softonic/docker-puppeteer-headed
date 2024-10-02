# docker-puppeteer-headed
Puppeteer is a Node library which provides a high-level API to control Chrome or Chromium over the DevTools Protocol. This repository provides a Docker image to run Puppeteer in a chrome browser using headed (full) mode.

This repository provides a Docker image with Puppeteer. 

## Build

To build the Docker image yourself you can run the command:

```shell script
docker build -t softonic/puppeteer-headed:latest .
```

## Usage

You just need to run it via Docker:

```shell script
docker run \
  --rm \
  --name my-puppeteer \
  --cap-add=SYS_ADMIN \
  --init \
  softonic/puppeteer-headed:latest
```

If you have a Javascript file to decide what and how to execute tests you could write your start file or an npm/yarn alias:

```shell script
docker run --rm --name my-puppeteer \
  --cap-add=SYS_ADMIN \
  --init \
  --workdir=/app \
  -v $PWD/:/app \
  softonic/puppeteer-headed:latest \
  yarn start
```
