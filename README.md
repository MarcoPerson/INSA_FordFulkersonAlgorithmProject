# INSA_FordFulkersonAlgorithmProject

Ocaml project on Ford-Fulkerson.

This project contains the basic Ford-Fulkerson Algorithm and a use-case of this algorithm.

For the Ford-Fulkerson Algorithm you can create a graph on [Graph Editor](https://algorithms.discrete.ma.tum.de/graph-algorithms/flow-ford-fulkerson/index_en.html) and get the maximum flow and the end flow graph with our Implementation.

For our use-case Jobs and Appliers which is based on the Maximum Bipartite Matching, the input are Jobs and the Appliers and the output is a maximum matching proposition.

A job is in the format "J [unique_id] : [number_of_places_available] [name_of_the_job]"

An Applier is in the format "A [applier_name] [job_id] [job_id] ..."

An Apllier can apply to multiple Jobs

You can then give a file as input that look like this

```bash
J 1 : 1 Prof de sport
J 2 : 2 Informaticien
J 3 : 1 Serveur
J 4 : 2 Estéticien
J 5 : 3 Mécanicien
J 6 : 1 Prof de Programmation
J 7 : 2 Boxeur
J 8 : 1 Danceuse
J 9 : 2 Pediatre
J 10 : 3 Ingénieur
J 11 : 1 Dermathologue
J 12 : 2 Cardiologue
J 13 : 1 Néphrologue
J 14 : 1 Gérant de Club

A Paul 3
A Ghizlane 1
A Amine 2 12
A Merveilles 3 1 2
A Marie 8 10
A Thomas 14
A Yu 8 7
A Sirine 7 14
A Wissal 5 4
A Adama 11 7
A Marc 12 6
A Tasnim 9 14
A Sofiane 5
A Walid 13
A Cristiano 3
```

and you will get an output like this

```bash
Result of the Appliers and Jobs entries

	Walid : Néphrologue
	Sofiane : Mécanicien
	Tasnim : Pediatre
	Marc : Cardiologue
	Adama : Dermathologue
	Wissal : Mécanicien
	Sirine : Boxeur
	Yu : Danceuse
	Thomas : Gérant de Club
	Marie : Ingénieur
	Merveilles : Informaticien
	Amine : Informaticien
	Ghizlane : Prof de sport
	Paul : Serveur

End of the result
```

You should install the _OCaml_ extension in VSCode and full compile as VSCode build task (Ctrl+Shift+b)

The makefile provides some useful commands:

- `make build` to compile. This creates an ftest.native executable
- `make demo` to run the `ftest` program with some arguments
- `make format` to indent the entire project
- `make edit` to open the project in VSCode
- `make clean` to remove build artifacts

In case of trouble with the VSCode extension (e.g. the project does not build, there are strange mistakes), a common workaround is to (1) close vscode, (2) `make clean`, (3) `make build` and (4) reopen vscode (`make edit`).

Merveilles AGBETI-MESSAN and Amine Alami mejjati
