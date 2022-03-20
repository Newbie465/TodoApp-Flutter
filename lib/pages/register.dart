import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_app/model/usermodel.dart';
import 'package:login_app/pages/todo.dart';
import './home.dart';

class registrationScreen extends StatefulWidget {
  const registrationScreen({ Key? key }) : super(key: key);

  @override
  State<registrationScreen> createState() => _registrationScreenState();
}

class _registrationScreenState extends State<registrationScreen> {
  
  final _auth = FirebaseAuth.instance;
  
  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = new TextEditingController();
  final secondtNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final dateEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmpasswordEditingController = new TextEditingController();
  
  
  
  @override
  Widget build(BuildContext context) {

    final firstNameField = TextFormField(

      autofocus: false,
      controller: firstNameEditingController,
      validator: (value){
        RegExp regex = new RegExp(r'^.{3,}$');
        if(value!.isEmpty){
          return 'First Name is required';
        }
        if(!regex.hasMatch(value)){
          print("passwordError");
          return "Min 3 Character required";
        }
      },
      onSaved: (value){

        firstNameEditingController.text = value!;

      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        labelText: 'First Name',
        border: OutlineInputBorder()
      ),

    );

    final secondNameField = TextFormField(

      autofocus: false,
      controller: secondtNameEditingController,
      validator: (value){
        RegExp regex = new RegExp(r'^.{3,}$');
        if(value!.isEmpty){
          return 'Second Name is required';
        }
        if(!regex.hasMatch(value)){
          print("passwordError");
          return "Min 3 Character required";
        }
      },
      onSaved: (value){

        secondtNameEditingController.text = value!;

      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        labelText: 'Second Name',
        border: OutlineInputBorder()
      ),

    );

    final emailField = TextFormField(

      autofocus: false,
      controller: emailEditingController,
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

        emailEditingController.text = value!;

      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        labelText: 'Email',
        border: OutlineInputBorder()
      ),

    );

    final DateTime selectedDate;
    final dateField = DateTimeFormField(

      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black45),
        errorStyle: TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.event_note),
        labelText: 'Date of Birth',
      ),
      mode: DateTimeFieldPickerMode.date,
      autovalidateMode: AutovalidateMode.always,
      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
      onDateSelected: (DateTime value) {
        print(value);
  },

    );

    final passwordField = TextFormField(

      autofocus: false,
      controller: passwordEditingController,
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

        passwordEditingController.text = value!;

      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        labelText: 'Password',
        border: OutlineInputBorder()
      ),

    );

    final confirmpasswordField = TextFormField(

      autofocus: false,
      controller: confirmpasswordEditingController,
      obscureText: true,
      validator: (value){        
        if(passwordEditingController.text != confirmpasswordEditingController.text && confirmpasswordEditingController.text.length > 6){
          return "Password does not match";
        }
        return null;
      },
      onSaved: (value){

        confirmpasswordEditingController.text = value!;

      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        labelText: 'Confirm Password',
        border: OutlineInputBorder()
      ),

    );

    final registerButton = Material(

      elevation: 7,
      borderRadius: BorderRadius.circular(50),
      color: Colors.green,
      child: MaterialButton(

        onPressed:() {

          signUp(emailEditingController.text, passwordEditingController.text);
          
        } ,
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          "Register", 
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[

                    SizedBox(
                        height: 75,
                        child: Text(
                          "Register",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                            
                          ),
                        ),
                      
                      ),
                      SizedBox(height: 20,),
                      firstNameField,
                      SizedBox(height: 20,),
                      secondNameField,
                      SizedBox(height: 20,),
                      emailField,
                      SizedBox(height: 20,),
                      dateField,
                      SizedBox(height: 20,),
                      passwordField,
                      SizedBox(height: 20,),
                      confirmpasswordField,
                      SizedBox(height: 20,),
                      registerButton,
                      SizedBox(height: 20,),


                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

  void signUp(String email, String password) async {

    if(_formKey.currentState!.validate()){
      await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {postDetailsToFirestore()})
        .catchError((e){

          Fluttertoast.showToast(msg: e!.message);
        }); 
          
        
        
    }
  }

  postDetailsToFirestore() async {

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;

      userModel usermodel = userModel();

      usermodel.email = user!.email;
      usermodel.uid = user.uid;
      usermodel.firstName = firstNameEditingController.text;
      usermodel.secondName = secondtNameEditingController.text;


      await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(usermodel.toMap());

      Fluttertoast.showToast(msg: "Account is Successfully created");

      Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => todoList()),(route)=>false);
  }
}
