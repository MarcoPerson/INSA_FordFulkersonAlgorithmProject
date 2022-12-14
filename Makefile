
build:
	@echo "\n==== COMPILING ====\n"
	ocamlbuild ftest.native

format:
	ocp-indent --inplace src/*

edit:
	code . -n

demo: build
	@echo "\n==== EXECUTING ====\n"
	./ftest.native graphs/graph1 0 5 graphs/outfile
	dot -Tsvg graphs/outfile > graphs/output-file.svg
	#@echo "\n==== RESULT ==== (content of outfile) \n"
	#@cat graphs/outfile

clean:
	-rm -rf _build/
	-rm ftest.native
