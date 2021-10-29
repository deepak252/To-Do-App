
class ToDo{
  final  String id;
  final String todoText;
  final bool done;
  final  time;


  ToDo({required this.todoText, required this.done, this.time, this.id = ""});

  Map<String,dynamic> toJson()=>{
    'todoText': this.todoText,
    'done': this.done,
    'time': this.time,
    'id': this.id
  };

  static ToDo fromJson(json)=>ToDo(
    todoText: json['todoText'], 
    done: json['done'],
    time: json['time'],
    id: json['id']
  );

}