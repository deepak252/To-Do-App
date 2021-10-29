
class ToDo{
  final String todoText;
  final bool done;
  final  time;

  ToDo({required this.todoText, required this.done, this.time});

  Map<String,dynamic> toJson()=>{
    'todoText': this.todoText,
    'done': this.done,
    'time': this.time
  };

  static ToDo fromJson(json)=>ToDo(
    todoText: json['todoText'], 
    done: json['done'],
    time: json['time']
  );

}