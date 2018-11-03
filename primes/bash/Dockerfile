FROM alpine:3.8

WORKDIR /app
COPY . /app

RUN apk update
RUN apk add bash

ENTRYPOINT bash compute.bash
