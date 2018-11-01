FROM alpine:3.8

WORKDIR /app

COPY . /app

ENV LUA_VERSION 5.3
ENV LUA_PACKAGE lua${LUA_VERSION}

RUN apk update
RUN apk add ${LUA_PACKAGE}

ENTRYPOINT ["lua5.3", "compute.lua"]
