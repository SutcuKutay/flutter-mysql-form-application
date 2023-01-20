import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_form_application/api_connection/api_connection.dart';
import 'package:mysql_form_application/models/user.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  var formkey = GlobalKey<FormState>();
  var nameCont = TextEditingController();
  var emailCont = TextEditingController();
  var passCont = TextEditingController();

  /*validateEmail() async{
    try{
      var response = await http.post(Uri.parse(API.validateEmail),
      body: {
        'email': emailCont.text.trim(),
      });
      if(response.statusCode == 200){
        var responseBody = json.decode(json.encode(response.body));
        if(responseBody == true)
          {
            Fluttertoast.showToast(msg: "Email is already in use by another account. Try another email.");
          }
        else
          {
            registerUser();
          }
      }
    }
    catch(e)
    {
      print(e.toString());
      print("validateEmail catchi");
      Fluttertoast.showToast(msg: e.toString());
    }
  }*/

  /*registerUser() async{
    User user = User(
      nameCont.text.trim(),
      emailCont.text.trim(),
      passCont.text.trim(),
    );

    try{
      var response = await http.post(Uri.parse(API.signupConnection),
      body: user.toJson());

      if(response.statusCode == 200)
        {
          var responseBody = json.decode(json.encode(response.body));
          print(responseBody);
          final String result = responseBody;
          if(result == "successful")
            {
              Fluttertoast.showToast(msg: "Registration successful.");
            }
          else
            {
              Fluttertoast.showToast(msg: "Error. Try again.");
            }
        }
    }
    catch(e){
      print(e.toString());
      print("register catchi");
      Fluttertoast.showToast(msg: e.toString());
    }
  }*/

  Future validateEmail() async{
    var response = await http.post(Uri.parse(API.newValidateEmail),body: {
      'email': emailCont.text,
    });
    var result = json.decode(response.body);

    if(result == "email_found")
    {
      Fluttertoast.showToast(msg: "Email already in use. Try another email.",
      textColor: Colors.white,
      backgroundColor: Colors.red);
    }
    else
    {
      registerUser();
    }
  }

  Future registerUser() async{
    var response = await http.post(Uri.parse(API.newSignupConnection),body: {
      'username' : nameCont.text,
      'email' : emailCont.text,
      'password' : passCont.text,
    });
    var result = json.decode(response.body);

    if(result == "success")
    {
      Fluttertoast.showToast(msg: "Registration successful.",
      textColor: Colors.white,
      backgroundColor: Colors.green);
    }
    else
    {
      Fluttertoast.showToast(msg: "Error. Try again.",
      textColor: Colors.white,
      backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        children: [
          TextFormField(
            controller: nameCont,
            decoration: const InputDecoration(hintText: "Username"),
            validator: (value){
              if(value == null || value.isEmpty){
                return "Username cant be empty.";
              }
              return null;
            },
          ),
          TextFormField(
            controller: emailCont,
            decoration: const InputDecoration(hintText: "Email"),
            validator: (value){
              if(value == null || value.isEmpty){
                return "Email cant be empty.";
              }
              return null;
            },
          ),
          TextFormField(
            controller: passCont,
            decoration: const InputDecoration(hintText: "Password"),
            validator: (value){
              if(value == null || value.isEmpty){
                return "Password cant be empty.";
              }
              return null;
            },
          ),
          ElevatedButton(onPressed: (){
            if(formkey.currentState!.validate())
            {
              validateEmail();
            }
          }, child: const Text("Sign Up"),),
        ],
      ),
    );
  }
}
