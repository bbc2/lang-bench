FROM alpine:3.8

WORKDIR /app
COPY . /app

RUN apk update
RUN apk add zsh

ENTRYPOINT zsh compute.zsh
