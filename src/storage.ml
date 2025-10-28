open Todolist

(* Helper function to convert one CSV string into a task record option *)
let csv_to_task line =
  match String.split_on_char ',' line with
  | [id_str; completed_str; desc_str] ->
      (try
        let id = int_of_string id_str in
        let completed = bool_of_string completed_str in
        (* Remove the quotes around the description *)
        let description = String.sub desc_str 1 (String.length desc_str - 2) in
        Some { id = id; description = description; completed = completed }
      with
      | _ -> None) (* Return None if conversion fails *)
  | _ -> None (* Return None if the line doesn't have exactly 3 parts *)

(* Helper function to convert one task into a CSV-formatted string *)
let task_to_csv task =
  let id_str = string_of_int (id task) in
  let completed_str = string_of_bool (completed task) in
  let desc_str = description task in
  (* Using Printf.sprintf is a clean way to format strings *)
  Printf.sprintf "%s,%s,\"%s\"\n" id_str completed_str desc_str

let load filepath : todo_list =
  if not (Sys.file_exists filepath) then
    [] (* If no file exists, return an empty list *)
  else
    let channel = open_in filepath in
    let rec read_lines acc =
      try
        let line = input_line channel in
        match csv_to_task line with
        | Some task -> read_lines (task :: acc) (* Add valid task to our list *)
        | None -> read_lines acc (* Ignore malformed lines *)
      with End_of_file ->
        close_in channel;
        List.rev acc (* Reverse the list to restore original order *)
    in
    read_lines []

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