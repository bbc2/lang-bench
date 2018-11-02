FROM ocaml/opam2:4.07
RUN opam switch 4.07
VOLUME /out
RUN mkdir -p /out
COPY compute.ml .
RUN opam exec -- ocamlopt compute.ml -o compute.exe
ENTRYPOINT ["./compute.exe"]
