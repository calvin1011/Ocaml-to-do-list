(** The public type for a single task. *)
type task = {
  id: int;
  description: string;
  completed: bool;
}

(** The public type for a list of tasks. *)
type todo_list = task list

(** [id task] returns the ID of the task. *)
val id : task -> int

(** [description task] returns the description of the task. *)
val description : task -> string

(** [completed task] returns the completion status of the task. *)
val completed : task -> bool

(** [create ()] returns an empty to-do list. *)
val create : unit -> todo_list

(** [add_task desc list] adds a new task with description [desc] to the [list]. *)
val add_task : string -> todo_list -> todo_list

(** [complete_task id list] marks the task with [id] as complete.
    Returns a new, updated list. *)
val complete_task : int -> todo_list -> todo_list

(** [remove_task id list] removes the task with [id] from the list.
    Returns a new, updated list. *)
val remove_task : int -> todo_list -> todo_list

(** [get_all_tasks list] returns a list of all tasks. *)
val get_all_tasks : todo_list -> task list