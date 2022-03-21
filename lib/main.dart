import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './pages/login.dart';
import './pages/todo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkuser();
  runApp(const MyApp());
}

User? user = FirebaseAuth.instance.currentUser;
Widget page = loginScreen();

void checkuser (){
  if(user != null){
    page = todoList();
    print("user Logged In");
  }else{
    print("User Log-In");
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: page
    );
  }
}
