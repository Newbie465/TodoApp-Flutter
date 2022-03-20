import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/usermodel.dart';

class todoList extends StatefulWidget {
  const todoList({ Key? key }) : super(key: key);

  @override
  State<todoList> createState() => _todoListState();
}

class _todoListState extends State<todoList> {

  final _auth = FirebaseAuth.instance;

  
  String input = '';

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  userModel tododata = userModel();
  List<dynamic> todos = [];
  List<dynamic> todosinit = [];


  //List todos = tododata.todos!; 
  
  
  
  @override
  void initState() {
    super.initState();
    //todos.add("item1");
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot){
          if(documentSnapshot.exists){
            Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
            todos.addAll(data['todos']);
            print(todos);
          }
          else{
            print('Data not found');
          }
          setState(() {});
        });

      //todos.addAll(todosinit);
  }

  
  void firedata() {
    firebaseFirestore
      .collection('users')
      .doc(user?.uid)
      .get()
      .then((DocumentSnapshot docs){
        if (docs.exists) {
          
          Map<String, dynamic> data = docs.data()! as Map<String, dynamic>;
          todos.addAll(data['todos']);
        }else{
          print('data not found');

        }
      });
      
  }


  createToDos(String input) async {
    


    todos.add(input);
    List<dynamic> addtodo  = ['$input'];
    // tododata.todos = {'todoTitle':todos};

    await firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .update({'todos':FieldValue.arrayUnion(addtodo)});

    Fluttertoast.showToast(msg: "To-Do Added");

  }

  removetodo(int index,String data) async {

    todos.removeAt(index);
    List<dynamic> subtodo  = ['$data'];

    await firebaseFirestore
      .collection('users')
      .doc(user!.uid)
      .update({'todos': FieldValue.arrayRemove(subtodo)});

     Fluttertoast.showToast(msg: "To-Do Deleted");
    // tododata.todos = {'todoTitle':todos};
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: Text('To-Do List'),
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
                      createToDos(input);
                      // setState(() {
                      //   todos.add(input);
                      // });
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
        stream: firebaseFirestore.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshots){
          if(snapshots.hasData){
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, index) {
                return Dismissible(
                  onDismissed: (direction) {
                    removetodo(index, todos[index]);
                    //removetodo(index);
                    //removetodo(index);
                    // setState(() {
                    //   todos.removeAt(index);
                    // });
                    //12
                  },
                  key: Key(todos[index]), 
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8) ),
                    child: ListTile(
                      title: Text(todos[index]),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,),
                        onPressed: () {
                          removetodo(index, todos[index]);
                          // todos.removeAt(index);
                          //removetodo(index);
                          // setState(() {
                          //   todos.removeAt(index);
                          // });
                        },  
                        ),
                    ),));
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