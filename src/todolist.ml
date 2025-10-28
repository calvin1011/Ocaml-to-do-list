(* we first define the concrete types that were abstract in the .mli file. *)
type task = {
  id: int;
  description: string;
  completed: bool;
}

type todo_list = task list

(* Getter functions to access task fields *)
let id task = task.id
let description task = task.description
let completed task = task.completed

(* Function implementations *)
let create () =
  [] (* An empty list is our empty to-do list *)

let get_all_tasks list =
  list (* Just return the list itself *)

let add_task description list =
    let next_id =
        let find_max_id max_id task = max task.id max_id in
        match list with 
        | [] -> 1
        | _ -> (List.fold_left find_max_id 0 list) + 1
    in

    (* create new task record *)
    let new_task = {
        id = next_id;
        description = description;
        completed = false;
    } in

    (* return a new list with the new task appended to the end *)
    list @ [new_task]
