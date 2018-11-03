ARG DISTRIBUTION_VERSION
# DISTRIBUTION_VERSION jessie stretch buster
#       Also all the *-slim variant
FROM debian:${DISTRIBUTION_VERSION}

ARG SOURCE

WORKDIR /app
COPY ./${SOURCE} /app/.

RUN apt-get update
RUN apt-get install -y luajit

ENTRYPOINT luajit compute.lua
