import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/services/todo_services.dart';

import '../device.dart';

class ToDoCard extends StatefulWidget {
  final ToDo todo;  
  ToDoCard({ Key? key, required this.todo }) : super(key: key);
  @override
  _ToDoCardState createState() => _ToDoCardState();
}



class _ToDoCardState extends State<ToDoCard> {
  bool editToDo = false;
  void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
    setState(() {
      editToDo = false;
    });
  }
  TextEditingController _todoEditController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    _todoEditController.text= widget.todo.todoText;
    _todoEditController.selection = TextSelection.fromPosition(
      TextPosition(offset: _todoEditController.text.length)
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            vertical: Device.height * 0.012, 
            horizontal: Device.width * 0.05
          ),
          leading: FaIcon(
            widget.todo.done ? FontAwesomeIcons.checkCircle :FontAwesomeIcons.circle,
            size: Device.height * 0.034,
            color: Device.primaryColor.withOpacity(0.9),
          ),
          title: editToDo 
          //  MediaQuery.of(context).viewInsets.bottom!=0 
          ? TextField(
            autofocus: true,
            controller: _todoEditController,
            decoration: InputDecoration(
              // border: InputBorder.none
            ),
          ) : Text(
            widget.todo.todoText,
          ),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  // Edit TO DO
                  setState(() {
                    editToDo = !editToDo;
                    if(!editToDo) unfocus(context);
                  });
                },
                child: Container(
                  color: editToDo
                  ? Colors.black.withOpacity(0.1)
                  : null,
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(
                    FontAwesomeIcons.edit,
                    color: Device.primaryColor,
                  ),
                ),
              ),
              // SizedBox(width: Device.width*0.02,),
              InkWell(
                onTap: () async {
                  // Delete TO DO
                  await TodoService.deleteToDo(widget.todo);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(
                    FontAwesomeIcons.trashAlt,
                    color: Device.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}