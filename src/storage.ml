open Todolist

(* Helper function to convert one task into a CSV-formatted string *)
let task_to_csv task =
  let id_str = string_of_int (id task) in
  let completed_str = string_of_bool (completed task) in
  let desc_str = description task in
  (* Using Printf.sprintf is a clean way to format strings *)
  Printf.sprintf "%s,%s,\"%s\"\n" id_str completed_str desc_str

(* The type `todo_list` is now available without the Todolist prefix *)
let load filepath : todo_list =
  failwith "Unimplemented: load"

let save filepath list =
  (* Open a channel to write to the file *)
  let channel = open_out filepath in
  (* We use try...finally to guarantee the file is closed, even if an error happens *)
  try
    (* Convert the whole list of tasks to a list of strings *)
    let lines = List.map task_to_csv list in
    
    (* Write each string line to the file *)
    List.iter (fun line -> output_string channel line) lines;
    
    (* Close the file channel *)
    close_out channel
  with e ->
    (* If an error occurred, close the channel and then re-raise the exception *)
    close_out_noerr channel;
    raise e