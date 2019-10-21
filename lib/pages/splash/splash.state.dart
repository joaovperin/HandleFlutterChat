import 'package:flutter/material.dart';
import 'package:handle_flutter_chat/core/users/users.service.dart';
import 'package:handle_flutter_chat/pages/home/home.page.dart';

import 'splash.page.dart';

///
/// A state for the splash screen
///
class SplashPageState extends State<SplashPage> {
  @override
  initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _loadUser() async {
    try {
      final currentUser =
          await UserService.getLoggedUserData(userNotLogged: () {
        Navigator.pushReplacementNamed(context, "/login");
      });
      // Navigate to home page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    title: currentUser.displayName + "'s Tasks",
                    uid: currentUser.uuid,
                    dname: currentUser.displayName,
                  )));
    } catch (err) {
      print(err);
    }
  }
}
