open Graph
open Tools

(*Exception for Inexistant id given for finding the path *)
exception Inexistant

(*Exception when we try to convert None into a value*)
exception Impossible

let depthSearch graph id_source id_puit = 

  (*Check if both ids given are in the graph, raise Inexistant if not*)
  if ((node_exists graph id_source) && (node_exists graph id_puit)) then

  (*Get all the arcs of the souce id*)
  let voisins = out_arcs graph id_source in

    (*Starting a depth search to get to id_puit*)
    let rec parcours list_voisin acc =
        match list_voisin with 

        (*Making sure we get to the id_puit with a label value greater than 0*)
         | (id_voisin1 , label ) :: tail -> if ( (id_voisin1 = id_puit)  && (label != 0)) then id_puit::acc else 
          
          (*Making sure we get the path or [] if there is no path*)
          let chemin = match ( (label = 0) ||  (List.exists  (fun x -> x = id_voisin1) acc )) with
            | true -> []
            | false -> parcours (out_arcs graph id_voisin1) (id_voisin1::acc) 
             in
          if (chemin = []) then parcours tail acc else chemin
         | [] -> []

         (*Return the reverse order of the path as we were adding element from the head*)
      in List.rev (parcours voisins [id_source])
  else raise Inexistant


let find_arc_bis graph id1 id2 = match (find_arc graph id1 id2) with 
  |Some a -> a 
  |None -> raise Impossible 


let flowList graph idlist  = 

  (*Getting the flow between every two id*)
  let rec loop idlist acu = match idlist with
    |a::b::tail -> loop (b::tail) ((find_arc_bis graph a b)::acu)
    |b::[] -> acu
    |[] -> acu in

    (*(*Return the reverse order as we were adding element from the head*)*)
    List.rev (loop idlist [])

    
let flowMin intlist = 

  (*Getting the minimum flow acceptable from the flowList of a path*)
  let rec loop intlist min = match intlist with
    |a::tail -> loop tail (Int.min min a) 
    |[] -> min in
    loop intlist Int.max_int


let updateFlow graph idlist = 

  (*Getting the min flow*)
  let minFlow = flowMin (flowList graph idlist) in

  (*Updating the flow on the found path*)
  let rec loop graph idlist = match idlist with
    |a::b::tail -> let g1 = (add_arc graph a b (-minFlow)) in 
      let g2 = (add_arc g1 b a minFlow) in loop g2 (b::tail)
    |b::[] -> graph
    |[] -> graph
    in loop graph idlist


let algoFulkerson graph id1 id2 = 

  (*Calling loop until we get an empty path and keep track of the sum of the min flows*)
  let rec loop graph value = match (depthSearch graph id1 id2) with
    |(a::tail) as liste -> 
      let minFlow = flowMin (flowList graph liste) in
        Printf.printf "Chemin : %s \n%!" (String.concat " -> " (List.map string_of_int liste));
        Printf.printf "Flow Min : %s \n%!" (string_of_int minFlow);

        (*Calling the loop on the updated flow graph*)
        loop (updateFlow graph liste) (value + minFlow)

    (*Returning the Maximum flow and the final flow graph*)
    |[] -> value, graph
  in loop graph 0


let finalGraphFlow graph id1 id2 = 
  
  (*Getting only the final graph without keeping track of the min flows*)
  let rec loop graph = match (depthSearch graph id1 id2) with
    |(a::tail) as liste -> loop (updateFlow graph liste)
    |[] -> graph
  in loop graph
