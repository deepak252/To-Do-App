import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do_app/device.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/services/todo_services.dart';
import 'package:to_do_app/widgets/todo_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _todoController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      print('Listener');
    });
  }

  void showKeyboard() {
    _focusNode.requestFocus();
  }

  void dismissKeyboard() {
    _focusNode.unfocus();
  }
  void unfocus() {
    _todoController.clear();
    dismissKeyboard();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Device.height = MediaQuery.of(context).size.height;
    Device.width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffdfdfeb),
      body: GestureDetector(
        // onTap: () => unfocus(context),
        onTap: () => dismissKeyboard(),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Device.width * 0.05,
            Device.height * 0.05, 
            Device.width * 0.05, 0
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "TO DO App",
                  style: TextStyle(
                    fontSize: Device.height * 0.055,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: Device.height * 0.02,
                    top: Device.height * 0.026,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          elevation: 6,
                          child: TextField(
                            focusNode: _focusNode,
                            controller: _todoController,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Device.width * 0.06,
                                vertical: Device.height * 0.02,
                              ),
                              hintText: " Type Something here...",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 0.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 0.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: _focusNode.hasFocus
                              ? IconButton(
                                onPressed: unfocus,
                                icon: Icon(Icons.clear, color: Device.primaryColor ),
                              ): null
                            ),
                            
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Device.width * 0.03,
                      ),
                      RawMaterialButton(
                        onPressed: () async {
                          showKeyboard();
                          var todoText = _todoController.text.trim();
                          if(todoText.length==0){
                            _todoController.clear();
                          }else{
                            await TodoService.addToDo(
                              ToDo(
                                todoText: todoText, 
                                done: false,
                                time: FieldValue.serverTimestamp()
                              )
                            );
                            _todoController.clear();
                            unfocus();
                          }
                        },
                        shape: CircleBorder(),
                        child: FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                        ),
                        fillColor: Device.primaryColor,
                        constraints: BoxConstraints.tightFor(
                          height: Device.height * 0.06,
                          width: Device.height * 0.06,
                        ),
                        elevation: 6,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: TodoService.fetchStream(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) { 
                        return Text('Something went wrong');
                      }if(snapshot.hasData){ // Loading done
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context,index){
                            Map<String, dynamic> json = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            json["id"] = snapshot.data!.docs[index].id;
                            return ToDoCard(todo: ToDo.fromJson(json));
                          }
                        );
                      }else{            // Loading
                        return Center(child: Text("Loading...."));
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
  
}
