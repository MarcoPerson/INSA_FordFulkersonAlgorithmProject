open Graph
open Tools

(*let depthSearch graph id_source id_puit = 
  if ((node_exists graph id_source) && (node_exists graph id_puit)) then

    let rec parcours_voisin list_voisin acc = match list_voisin with
      |(a , _ )::tail ->  if ((parcours a acc) = []) then parcours_voisin tail acc 
      |[]->raise Not_found

    and parcours ids acc =
      let voisins = out_arcs ids in 
        match voisins with
         | (id_voisin1 , _ ) :: tail -> if (id_voisin1 = id_puit) then id_puit::acc else 
          parcours_voisin tail acc
         | [] -> []
        in parcours id_source []*)

(*let arc_is_zero gr id1 id2 = 
  match (find_arc gr id1 id2) with 
  |None -> raise Not_found
  |Some 0 -> true
  |Some a -> false
*)

exception Inexistant
exception Impossible

let depthSearch graph id_source id_puit = 
  if ((node_exists graph id_source) && (node_exists graph id_puit)) then
  let voisins = out_arcs graph id_source in
    let rec parcours list_voisin acc =
        match list_voisin with 
         | (id_voisin1 , label ) :: tail -> if ( (id_voisin1 = id_puit)  && (label != 0)) then id_puit::acc else 
          
          let chemin = match ( (label = 0) ||  (List.exists  (fun x -> x = id_voisin1) acc )) with
            | true -> []
            | false -> parcours (out_arcs graph id_voisin1) (id_voisin1::acc) 
             in
          if (chemin = []) then parcours tail acc else chemin
         | [] -> []
      in List.rev (parcours voisins [id_source])
  else raise Inexistant

let find_arc_bis graph id1 id2 = match (find_arc graph id1 id2) with 
  |Some a -> a 
  |None -> raise Impossible 

let flowList graph idlist  = 
  let rec loop idlist acu = match idlist with
    |a::b::tail -> loop (b::tail) ((find_arc_bis graph a b)::acu)
    |b::[] -> acu
    |[] -> acu in
    List.rev (loop idlist [])

let flowMin intlist = 
  let rec loop intlist min = match intlist with
    |a::tail -> loop tail (Int.min min a) 
    |[] -> min in
    loop intlist Int.max_int


let updateFlow graph idlist = 
  let minFlow = flowMin (flowList graph idlist) in
  let rec loop graph idlist = match idlist with
    |a::b::tail -> let g1 = (add_arc graph a b (-minFlow)) in 
      let g2 = (add_arc g1 b a minFlow) in loop g2 (b::tail)
    |b::[] -> graph
    |[] -> graph
    in loop graph idlist

let algoFulkerson graph id1 id2 = 
  let rec loop graph value = match (depthSearch graph id1 id2) with
    |(a::tail) as liste -> 
      let minFlow = flowMin (flowList graph liste) in
        Printf.printf "Chemin : %s \n%!" (String.concat " -> " (List.map string_of_int liste));
        Printf.printf "Flow Min : %s \n%!" (string_of_int minFlow);
        loop (updateFlow graph liste) (value + minFlow)
    |[] -> value
  in loop graph 0

let finalGraphFlow graph id1 id2 = 
  let rec loop graph = match (depthSearch graph id1 id2) with
    |(a::tail) as liste -> loop (updateFlow graph liste)
    |[] -> graph
  in loop graph
