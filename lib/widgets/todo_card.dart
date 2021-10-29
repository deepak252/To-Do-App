import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/services/todo_services.dart';
import '../device.dart';

class ToDoCard extends StatefulWidget {
  final ToDo todo;
  ToDoCard({Key? key, required this.todo}) : super(key: key);
  @override
  _ToDoCardState createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  TextEditingController _todoEditController = TextEditingController();
  bool editToDo = false;
  
  void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
    setState(() {
      editToDo = false;
    });
  }

  @override
  void dispose() {
    _todoEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _todoEditController.text = widget.todo.todoText;
    _todoEditController.selection = TextSelection.fromPosition( // place cursor at last position.
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
          leading: InkWell(
            onTap: () async {
              // Mark/Unmark todo done
              await TodoService.updateToDo(
                widget.todo, {"done": !widget.todo.done}
              );
            },
            child: FaIcon(
              widget.todo.done
              ? FontAwesomeIcons.checkCircle
              : FontAwesomeIcons.circle,
              size: Device.height * 0.036,
              color: Device.primaryColor.withOpacity(0.9),
            ),
          ),
          title: editToDo
          ? TextField(  // Edit ToDo text field
              autofocus: true,
              controller: _todoEditController,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none
              ),
            )
          : Text(
              widget.todo.todoText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: editToDo 
                ? () async {
                  // update todo text
                  await TodoService.updateToDo(
                    widget.todo,
                    {
                      "todoText": _todoEditController.text
                    }
                  );
                  setState(() {
                    editToDo = false;
                    unfocus(context);
                  });
                }
                : () {
                  // Edit todo text
                  setState(() {
                    editToDo = !editToDo;
                    if (!editToDo) unfocus(context);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(
                    editToDo ? FontAwesomeIcons.check : FontAwesomeIcons.edit,
                    color: Device.primaryColor,
                    size: Device.height * 0.034,
                  ),
                ),
              ),
              InkWell(
                onTap: editToDo
                  ?(){
                    // Close todo editing
                    setState(() {
                      editToDo = false;
                      unfocus(context);
                    });
                  }
                : () async {
                  // Delete todo
                  await TodoService.deleteToDo(widget.todo);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(
                    editToDo ? FontAwesomeIcons.times : FontAwesomeIcons.trashAlt,
                    color: Device.primaryColor,
                    size: Device.height * 0.034,
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