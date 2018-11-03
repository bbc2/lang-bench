ARG DISTRIBUTION_VERSION
FROM alpine:${DISTRIBUTION_VERSION}

ARG SOURCE

WORKDIR /app
COPY ./${SOURCE} /app/.

RUN apk update
RUN apk add luajit

ENTRYPOINT luajit compute.lua
