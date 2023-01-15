open Graph
open Tools

(*Find a path from the first id to the second id on the graph *)
val depthSearch: int graph -> id -> id -> id list

(*Returns a list of the flows between the id in the list*)
val flowList: int graph -> id list ->  int list

(*Transforms the value resturned by find_arc as an int if it's Some x and raises Impossile if None*)
val find_arc_bis : int graph -> id -> id -> int

(*Updates the flow graph according to the found path*)
val updateFlow : int graph -> id list -> int graph

(*Returns a tuple with the max flow and the final graph*)
val algoFulkerson : int graph -> id -> id -> int*int graph

(*returns the final flow graph*)
val finalGraphFlow : int graph -> id -> id -> int graph
