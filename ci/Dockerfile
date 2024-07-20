FROM ocaml/opam:alpine
RUN sudo apk add ncurses
RUN opam switch 5.2
COPY --chown=opam:opam . .
RUN opam pin --no-action -y add .
RUN opam depext --update lang-bench
RUN opam install --deps-only --with-test lang-bench
