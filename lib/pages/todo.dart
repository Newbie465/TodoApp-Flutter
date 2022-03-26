import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/usermodel.dart';
import 'login.dart';

class todoList extends StatefulWidget {
  const todoList({ Key? key }) : super(key: key);

  @override
  State<todoList> createState() => _todoListState();
}

class _todoListState extends State<todoList> {

  final _auth = FirebaseAuth.instance;

  
  String input = '';
  String update = '';

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  
  @override
  void initState() {
    super.initState();
  }
 
  create() {
    DocumentReference documentReference = firebaseFirestore.collection('users').doc(user!.uid).collection('todos').doc(input);

    Map<String, dynamic> todos = {
      "todoTitle" : input
    };
    
    documentReference.set(todos).whenComplete((){
      print("$input created");
    });
  } 

  delete(item) async{
    DocumentReference documentReference = firebaseFirestore.collection('users').doc(user!.uid).collection('todos').doc(item);

    await documentReference.delete().whenComplete((){
      print("$item deleted");
    });
  }

  updatetodo(edit) {
    DocumentReference documentReference1 = firebaseFirestore.collection('users').doc(user!.uid).collection('todos').doc(edit);
    DocumentReference documentReference2 = firebaseFirestore.collection('users').doc(user!.uid).collection('todos').doc(update);

    documentReference1.delete();
    documentReference2.set({'todoTitle': update}).whenComplete((){
      print("$edit updated");
    });
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => loginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                logout(context);
              },
              child: Icon(
                Icons.exit_to_app,
              ),
            ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                title: Text("Add ToDo List"),
                content: TextField(
                  onChanged: (String value){
                    input = value;
                  },
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      create();
                      Navigator.of(context).pop();
                    }, 
                    child: Text("Add"))
                ],
              );
              
            });
        },
        child: Icon(Icons.add),
        elevation: 7, 
      ),
      body:StreamBuilder(
        stream: firebaseFirestore.collection('users').doc(user!.uid).collection('todos').snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                return Dismissible(
                  direction: DismissDirection.none,
                  key: Key(index.toString()), 
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8) ),
                    child: ListTile(
                      title: Text(documentSnapshot['todoTitle']),
                      trailing: SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                ),
                              onPressed: () {
                                showDialog(
                                  context: context, 
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      title: Text("Edit ToDo List"),
                                      content: TextField(
                                        onChanged: (String value){
                                          update = value;
                                        },
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            //create();
                                            updatetodo(documentSnapshot['todoTitle']);
                                            Navigator.of(context).pop();
                                          }, 
                                          child: Text("Edit"))
                                      ],
                                    );
                                    
                                  });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,),
                                onPressed: () {
                                  delete(documentSnapshot['todoTitle']);
                                },
                            ),
                            
                          ]
                        )  
                      ),
                      
                    ),
                  )
                );
            });
          }else {
              return Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              );
          }
              },
              )
          );
        }
      }