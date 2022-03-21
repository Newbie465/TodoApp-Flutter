import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_app/pages/todo.dart';

import './register.dart';
import './home.dart';


class loginScreen extends StatefulWidget {
  const loginScreen({ Key? key }) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(

      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){

          if(value!.isEmpty){
            return "Email is required";
          }
          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
            print("emailError");
            return "Please enter a valid Email";
          }
          return null;

      },
      onSaved: (value){

        emailController.text = value!;

      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        labelText: 'Email',
        border: OutlineInputBorder()
      ),

    );

    final passwordField = TextFormField(

      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value){
        RegExp regex = new RegExp(r'^.{6,}$');
        if(value!.isEmpty){
          return 'Password is required';
        }
        if(!regex.hasMatch(value)){
          print("passwordError");
          return "Enter Valid Password(Min 6 Character";
        }
      },
      onSaved: (value){

        passwordController.text = value!;

      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        labelText: 'Password',
        border: OutlineInputBorder()
      ),

    );

    final loginButton = Material(

      elevation: 5,
      borderRadius: BorderRadius.circular(50),
      color: Colors.green,
      child: MaterialButton(

        onPressed:() {
          signIn(emailController.text, passwordController.text);
        } ,
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          "Login", 
          textAlign: TextAlign.center,
          style: TextStyle(

            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          
          ),
          
        )

      ),


    );

    return Scaffold(

      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child:Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Form(
                key: _formKey,
                child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(
                        height: 75,
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                            
                          ),
                        ),
                      
                      ),

                      SizedBox(height: 20,),
                      emailField,
                      SizedBox(height: 20,),
                      passwordField,
                      SizedBox(height: 20,),
                      loginButton,
                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                            Text("New to the App? " ,style: TextStyle(fontSize: 17),),
                            GestureDetector(onTap: () {

                                Navigator.push(context, MaterialPageRoute(builder: (context) => registrationScreen(),));

                            },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.green, 
                                ),
                              ),
                            )

                        ],
                      )
                    ],

                  ), 
               ),
            )
            )
          )
      
      ,)

    );
  }
  void signIn(String email, String password) async{
    if(_formKey.currentState!.validate()){
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
            Fluttertoast.showToast(msg: "Login Successfull"),
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => todoList()))
          }).catchError((e){
            Fluttertoast.showToast(msg: e!.message);
          });
    }
  }

  
}

