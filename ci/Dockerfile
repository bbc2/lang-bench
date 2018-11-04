FROM ocaml/opam2:alpine
RUN sudo apk add ncurses
RUN opam switch 4.07 || opam switch create ocaml-base-compiler.4.07
COPY --chown=opam:root . .
RUN opam pin --no-action -y add .
RUN opam depext --update lang-bench
RUN opam install --deps-only --with-test lang-bench
