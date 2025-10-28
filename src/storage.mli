(** The abstract type for a to-do list.
    We need to refer to it, so we bring it in from the Todolist module. *)
type todo_list = Todolist.todo_list

(** load a to-do list from the file at [filepath].
    If the file does not exist, it returns an empty list. *)
val load : string -> todo_list

(** save the given [list] to the file at [filepath]. *)
val save : string -> todo_list -> unit