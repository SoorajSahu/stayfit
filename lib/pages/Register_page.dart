import 'dart:convert';
import '../sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:Stayfit/pages/All_apps.dart';
import 'login_page.dart';
import '../apilink.dart';
import 'package:http/http.dart' as http;

class StayFitApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<StayFitApp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(resizeToAvoidBottomInset: false, body: _body());
  }

  Signup(String name, String email, String pass) async {
    var json = jsonEncode(
        <String, String>{"name": name, "email": email, "password": pass});
    final response = await http.post(
        Uri.https(ApiLink().getBaseLink(), ApiLink().getSignUpLink()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
    print(response.body);
    if (response.statusCode.toString() == '201') {
      print('User Successfully created.   Please login to Continue.');
      Popup('User Successfully created.   Please login to Continue.');
    } else if (response.statusCode.toString() == '200') {
      print('You have already an account. Please login to Continue.');
      Popup('You have already an account. Please login to Continue.');
    }
  }

  Popup(String message) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text("$message"),
              actions: [
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () => {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => LogIn()))
                  },
                ),
              ],
            ));
  }

  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email';
    else
      return null;
  }

  _body() {
    return Scaffold(
      appBar: AppBar(title: Text('SIGN UP'), centerTitle: true),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'images/logo.png',
                  width: 150,
                ),
                alignment: Alignment.center,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      builduserNameFormField(),
                      SizedBox(height: 30),
                      buildEmailFormField(),
                      SizedBox(height: 30),
                      buildpasswordNumberFormField(),
                      SizedBox(height: 30),
                      FlatButton(
                        child: Text("CONTINUE"),
                        color: Colors.blue,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) => Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(),
                                    ));
                            Signup(nameController.text, emailController.text,
                                passwordController.text);
                          } else {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      content: const Text(
                                          'Please enter the valid Details'),
                                      actions: [
                                        TextButton(
                                          child: const Text('Ok'),
                                          onPressed: () =>
                                              {Navigator.pop(context)},
                                        ),
                                      ],
                                    ));
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have account ?'),
                          TextButton(
                            child: Text(
                              "Login.",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => LogIn()));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildpasswordNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      onSaved: (newValue) => passwordController.text = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          emailController.text = value;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(),
          hintText: "************",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.password_rounded)),
      obscureText: true,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Password is required';
        }
      },
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      onSaved: (newValue) => emailController.text = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          emailController.text = value;
        }
        return null;
      },
      validator: validateEmail,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Email",
        hintText: "Enter your Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.mail_rounded),
      ),
    );
  }

  TextFormField builduserNameFormField() {
    return TextFormField(
      onSaved: (newValue) => nameController.text = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          nameController.text = value;
        }

        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter Your Name";
        }
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "User Name",
          hintText: "Enter your Name",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }
}
