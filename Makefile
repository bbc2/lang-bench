.PHONY: all
all: build doc test

.PHONY: build
build:
	@dune build

.PHONY: doc
doc:
	@dune build @doc

.PHONY: exec
exec:
	@dune exec -- ./bench_cli/cli.exe

.PHONY: test
test:
	@dune runtest

.PHONY: clean
clean:
	@dune clean
