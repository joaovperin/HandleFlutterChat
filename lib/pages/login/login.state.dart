import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handle_flutter_chat/core/ui/dialogs/dialogs.service.dart';
import 'package:handle_flutter_chat/core/ui/loading/loading.service.dart';
import 'package:handle_flutter_chat/core/validators/validators.dart';
import 'package:handle_flutter_chat/pages/home/home.page.dart';

import 'login.page.dart';

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  _buildEmailTextField(),
                  _buildPasswordTextField(),
                  _buildLoginButton(context),
                  Text("Don't have an account yet?"),
                  FlatButton(
                    child: Text("Register here!"),
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                  )
                ],
              ),
            ))));
  }

  RaisedButton _buildLoginButton(BuildContext context) {
    return RaisedButton(
      child: Text("Login"),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: () {
        if (_loginFormKey.currentState.validate()) {
          final _loadingCompleter = LoadingService.show(context);
          _loadingCompleter.future.catchError((err) {
            print(err);
            DialogsService.errorException(context, error: err);
          });
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailInputController.text,
                  password: pwdInputController.text)
              .then((currentUser) => Firestore.instance
                      .collection("users")
                      .document(currentUser.user.uid)
                      .get()
                      .then((DocumentSnapshot result) {
                    _loadingCompleter.complete();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                title: result["displayname"] + "'s Tasks",
                                uid: currentUser.user.uid,
                                dname: result["displayname"])));
                  }).catchError((err) => _loadingCompleter.completeError(err)))
              .catchError((err) => _loadingCompleter.completeError(err));
        }
      },
    );
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password*', hintText: "********"),
      controller: pwdInputController,
      obscureText: true,
      validator: Validators.password,
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: 'Email*', hintText: "john.doe@gmail.com"),
      controller: emailInputController,
      keyboardType: TextInputType.emailAddress,
      validator: Validators.email,
    );
  }
}
