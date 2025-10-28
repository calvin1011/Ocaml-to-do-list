(* A helper to reliably find the user's home directory on any OS *)
let get_home_dir () =
  try Sys.getenv "HOME" (* For Unix-like systems (Linux, macOS) *)
  with Not_found ->
    try Sys.getenv "USERPROFILE" (* For Windows *)
    with Not_found ->
      prerr_endline "Error: Could not find HOME or USERPROFILE environment variable.";
      exit 1 (* Exit the program with an error code *)

(* Define where the tasks file will be stored. *)
let tasks_file = Filename.concat (get_home_dir ()) ".tasks.csv"

(* A helper function to print the list of tasks to the console *)
let print_tasks list =
  print_endline "ID | Status | Description";
  print_endline "---+--------+------------------";
  List.iter
    (fun task ->
      let status = if Todolist.completed task then "[x]" else "[ ]" in
      Printf.printf "%2d | %-6s | %s\n" (Todolist.id task) status
        (Todolist.description task))
    (Todolist.get_all_tasks list)

(* The main logic of the application *)
let () =
  (* Load the to-do list from the file at the start *)
  let initial_list = Storage.load tasks_file in

  let command = if Array.length Sys.argv > 1 then Some Sys.argv.(1) else None in

  (* Match the command to decide what to do *)
  let final_list =
    match command with
    | Some "list" ->
        print_tasks initial_list;
        initial_list (* No changes made *)
    | Some "add" ->
        if Array.length Sys.argv > 2 then
          let description = Sys.argv.(2) in
          let updated_list = Todolist.add_task description initial_list in
          print_endline "Task added.";
          print_tasks updated_list;
          updated_list
        else (
          print_endline "Error: 'add' command requires a description.";
          initial_list)
    | Some ("done" | "remove" as cmd) ->
        if Array.length Sys.argv > 2 then
          (try
            let id = int_of_string Sys.argv.(2) in
            let updated_list =
              if cmd = "done" then
                Todolist.complete_task id initial_list
              else (* cmd must be "remove" *)
                Todolist.remove_task id initial_list
            in
            Printf.printf "Task %d %s.\n" id (if cmd = "done" then "completed" else "removed");
            print_tasks updated_list;
            updated_list
          with Failure _ ->
            print_endline "Error: Please provide a valid task ID number.";
            initial_list)
        else (
          Printf.printf "Error: '%s' command requires a task ID.\n" cmd;
          initial_list)
    | _ ->
        print_endline "\nUsage: todo <command> [arguments]";
        print_endline "  list                    - Shows all tasks";
        print_endline "  add \"<description>\"   - Adds a new task";
        print_endline "  done <id>               - Marks a task as complete";
        print_endline "  remove <id>             - Removes a task";
        initial_list
  in

  (* Save the list back to the file *)
  Storage.save tasks_file final_list