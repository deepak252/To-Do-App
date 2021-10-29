import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/models/to_do.dart';

class TodoService{
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static CollectionReference _todo = _firestore.collection("ToDo");
  
  static Future addToDo(ToDo todo) async{
    _todo.add(todo.toJson())
    .then((value){
      log("ToDo added: ${todo.todoText}");
    })
    .catchError((error){
      log("addToDo exception: $error");
    });
  }

  static Stream<QuerySnapshot<Object?>> fetchStream() async*{
    yield* _todo.snapshots();
  }

}