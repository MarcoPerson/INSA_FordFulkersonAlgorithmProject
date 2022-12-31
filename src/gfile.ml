open Graph
open Printf
    
type path = string

(* Format of text files:
   % This is a comment

   % A node with its coordinates (which are not used), and its id.
   n 88.8 209.7 0
   n 408.9 183.0 1

   % Edges: e source dest label id  (the edge id is not used).
   e 3 1 11 0 
   e 0 2 8 1

*)

(* Compute arbitrary position for a node. Center is 300,300 *)
let iof = int_of_float
let foi = float_of_int

let index_i id = iof (sqrt (foi id *. 1.1))

let compute_x id = 20 + 180 * index_i id

let compute_y id =
  let i0 = index_i id in
  let delta = id - (i0 * i0 * 10 / 11) in
  let sgn = if delta mod 2 = 0 then -1 else 1 in

  300 + sgn * (delta / 2) * 100
  

let write_file path graph =

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "%% This is a graph.\n\n" ;

  (* Write all nodes (with fake coordinates) *)
  n_iter_sorted graph (fun id -> fprintf ff "n %d %d %d\n" (compute_x id) (compute_y id) id) ;
  fprintf ff "\n" ;

  (* Write all arcs *)
  let _ = e_fold graph (fun count id1 id2 lbl -> fprintf ff "e %d %d %d %s\n" id1 id2 count lbl ; count + 1) 0 in
  
  fprintf ff "\n%% End of graph\n" ;
  
  close_out ff ;
  ()


(* Reads a line with a node. *)
let read_node graph line =
  try Scanf.sscanf line "n %f %f %d" (fun _ _ id -> new_node graph id)
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Ensure that the given node exists in the graph. If not, create it. 
 * (Necessary because the website we use to create online graphs does not generate correct files when some nodes have been deleted.) *)
let ensure graph id = if node_exists graph id then graph else new_node graph id

(* Reads a line with an arc. *)
let read_arc graph line =
  try Scanf.sscanf line "e %d %d %_d %s@%%"
        (fun id1 id2 label -> new_arc (ensure (ensure graph id1) id2) id1 id2 label)
  with e ->
    Printf.printf "Cannot read arc in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a comment or fail. *)
let read_comment graph line =
  try Scanf.sscanf line " %%" graph
  with _ ->
    Printf.printf "Unknown line:\n%s\n%!" line ;
    failwith "from_file"

let from_file path =

  let infile = open_in path in

  (* Read all lines until end of file. *)
  let rec loop graph =
    try
      let line = input_line infile in

      (* Remove leading and trailing spaces. *)
      let line = String.trim line in

      let graph2 =
        (* Ignore empty lines *)
        if line = "" then graph

        (* The first character of a line determines its content : n or e. *)
        else match line.[0] with
          | 'n' -> read_node graph line
          | 'e' -> read_arc graph line

          (* It should be a comment, otherwise we complain. *)
          | _ -> read_comment graph line
      in      
      loop graph2

    with End_of_file -> graph (* Done *)
  in

  let final_graph = loop empty_graph in
  
  close_in infile ;
  final_graph
  
let export path graph = 
  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "digraph finite_state_machine {\n
    fontname=\"Helvetica,Arial,sans-serif\"\n
    node [fontname=\"Helvetica,Arial,sans-serif\"]\n
    edge [fontname=\"Helvetica,Arial,sans-serif\"]\n
    rankdir=LR;\n
    node [shape = circle];\n";

  (* Write all arcs *)
  e_iter graph (fun id1 id2 lbl -> fprintf ff "\t%d -> %d [label = %s]\n" id1 id2 lbl);

  fprintf ff "}\n" ;

  close_out ff ;
  ()



(*Reading the file for the bipatern matching problem : Enployee and Job available*)
let job_map = Hashtbl.create 500
let applier_map = Hashtbl.create 500
let id_incr = 1000
let ref_id_incr = ref id_incr

let split_to_int str applier_id graph = 
  let split_liste = String.split_on_char ' ' str in 
  let split_int = List.map int_of_string split_liste in
  let rec loop graph liste = match liste with
    |[] -> graph
    |job_id::tail -> loop (new_arc (ensure graph job_id) applier_id job_id "1") tail
in loop graph split_int

(* Reads a line with an applier. *)
let read_applier graph line =
  try Scanf.sscanf line "A %s %s@%%" (fun name jobs_id -> 
    Hashtbl.add applier_map !ref_id_incr name;
    ref_id_incr := !ref_id_incr + 1;
    let update_graph = new_arc (ensure graph (!ref_id_incr - 1)) 0 (!ref_id_incr - 1) "1" in
    split_to_int jobs_id (!ref_id_incr - 1) update_graph)
  with e ->
    Printf.printf "Cannot read applier in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a line with a job. *)
let read_job graph line =
   
  try Scanf.sscanf line "J %d : %s %s@%%"
        (fun job_id label name -> 
          Hashtbl.add job_map job_id name;
          new_arc (ensure graph job_id) job_id (-1) label)

  with e ->
    Printf.printf "Cannot read job in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

let from_file_problem path =

  let infile = open_in path in

  (* Read all lines until end of file. *)
  let rec loop graph =
    try
      let line = input_line infile in

      (* Remove leading and trailing spaces. *)
      let line = String.trim line in

      let graph2 =
        (* Ignore empty lines *)
        if line = "" then graph

        (* The first character of a line determines its content : n or e. *)
        else match line.[0] with
          | 'J' -> read_job graph line
          | 'A' -> read_applier graph line

          (* It should be a comment, otherwise we complain. *)
          | _ -> read_comment graph line
      in      
      loop graph2

    with End_of_file -> graph (* Done *)
  in

  let final_graph = loop (new_node (new_node empty_graph 0) (-1)) in
  
  close_in infile ;
  final_graph

let export_job_applier path graph = 
  (* Open a write-file. *)
  let ff = open_out path in
    fprintf ff "Result of the Appliers and Jobs entries\n\n";
    let all_applier = (out_arcs graph 0) in
      let rec loop liste_applier = match liste_applier with
        |[] -> fprintf ff "\nEnd of the result \n"
        |(applier_id, _)::tail -> 
            let job_get_liste = (out_arcs graph applier_id) in
              let rec second_loop liste_job = match liste_job with
                |[] -> loop tail
                |(job_id, label)::second_tail -> if label == 0 
                                    then ((fprintf ff "\t%s : %s\n" (Hashtbl.find applier_map applier_id) (Hashtbl.find job_map job_id)); loop tail)
                                    else (second_loop second_tail)
              in second_loop job_get_liste
      in loop all_applier;
    fprintf ff "\n" ;
    close_out ff ;
  ()
