open Graph
open Tools

val depthSearch: int graph -> id -> id -> id list

val flowList: int graph -> id list ->  int list

val find_arc_bis : int graph -> id -> id -> int

val updateFlow : int graph -> id list -> int graph

val algoFulkerson : int graph -> id -> id -> int

val finalGraphFlow : int graph -> id -> id -> int graph

(*val arc_is_zero: int graph -> id -> id -> bool*)