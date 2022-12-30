
build:
	@echo "\n==== COMPILING ====\n"
	ocamlbuild ftest.native

format:
	ocp-indent --inplace src/*

edit:
	code . -n

demo: build
	@echo "\n==== EXECUTING ====\n"
	./ftest.native graphs/problem.txt 0 -1 graphs/end_flow_graph.txt
	dot -Tsvg graphs/end_flow_graph.txt > graphs/end_flow_graph.svg
	dot -Tsvg graphs/start_graph.txt > graphs/start_graph.svg
	#@echo "\n==== RESULT ==== (content of outfile) \n"
	#@cat graphs/outfile

clean:
	-rm -rf _build/
	-rm ftest.native
