ARG DISTRIBUTION_VERSION
# DISTRIBUTION_VERSION jessie stretch buster
#       Also all the *-slim variant
# wheezy doesn't support apt-get update
FROM debian:${DISTRIBUTION_VERSION}

ARG SOURCE

WORKDIR /app
COPY ./${SOURCE} /app/.

ARG LUA_VERSION
# LUA_VERSION jessie 50-5.2
#             stretch-* 50-5.3
ENV LUA_PACKAGE lua${LUA_VERSION}

RUN apt-get update
RUN apt-get install -y ${LUA_PACKAGE}

ENV LUA_EXEC=lua${LUA_VERSION}
ENTRYPOINT $LUA_EXEC compute.lua
