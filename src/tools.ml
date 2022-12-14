open Graph

let clone_nodes (gr:'a graph) = n_fold gr new_node empty_graph
  
let gmap gr f = 
  let g1 = clone_nodes gr in
  e_fold gr (fun x id1 id2 v -> new_arc x id1 id2 (f v)) g1

let add_arc gr id1 id2 v = let var = find_arc gr id1 id2 in
  match var with
  |None -> new_arc gr id1 id2 v
  |Some x -> new_arc gr id1 id2 (x+v)