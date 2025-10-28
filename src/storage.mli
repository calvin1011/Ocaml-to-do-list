(** [load filepath] loads a to-do list from the file at [filepath].
    If the file does not exist, it returns an empty list. *)
val load : string -> Todolist.todo_list

(** [save filepath list] saves the given [list] to the file at [filepath]. *)
val save : string -> Todolist.todo_list -> unit