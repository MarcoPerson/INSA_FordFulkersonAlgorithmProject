open Gfile
open Tools
open Fulkerson

let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)

  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)

  (* These command-line arguments are not used for the moment. *)
  and source = int_of_string Sys.argv.(2)
  and sink = int_of_string Sys.argv.(3)
  in

  (* Open file *)

  (*To use only the Fulkerson algorithm*)
  (*let graph = from_file infile in*)

  (*To use the Maximum Bipartite Matching algorithm*)
  let graph = from_file_problem infile in

  (* Rewrite the graph that has been read. *)
  (*let gr = clone_nodes graph in*)
  (*let () = Printf.printf "Le chemin trouvé est: %s \n%!" (String.concat " -> " (List.map string_of_int (depthSearch (gmap graph int_of_string) source sink))) in
  let () = Printf.printf "Les flow trouvé sont: %s \n%!" (String.concat " -> " (List.map string_of_int (flowList (gmap graph int_of_string) (depthSearch (gmap graph int_of_string) source sink)))) in*)
  (*let () = Printf.printf "Le flow maximale est: %s \n%!" (string_of_int (algoFulkerson (gmap graph int_of_string) source sink)) in*)
  let () = export "graphs/start_graph.txt" graph in
  let () = match (algoFulkerson (gmap graph int_of_string) source sink) with
    |(value, final_graph) ->  
      Printf.printf "Le flow maximale est: %s \n%!" (string_of_int value);
      export_job_applier "graphs/problem_result.txt" final_graph;
      export outfile (gmap final_graph string_of_int)
    in
  (*let () = write_file outfile graph in*)

  ()

