ARG VERSION
FROM rust:${VERSION}

ARG DEBUG=false

WORKDIR /app
COPY ./primes/src /app/src/
COPY ./primes/Cargo.toml /app/
COPY ./primes/Cargo.lock /app/

RUN if $DEBUG; then cargo install --debug --path .; else cargo install --path .; fi

ENTRYPOINT primes
