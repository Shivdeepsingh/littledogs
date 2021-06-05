import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/tabscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  Future<Null> checkIsLogin() async {
    String email = "";
    String token = "";
    int userId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email");
    token = prefs.getString("token");
    userId = prefs.getInt("userId");

    final appState = Provider.of<AppState>(context, listen: false);
    print(email);
    print(token);
    print(userId);
    print("data user");
    if (token != "" && token != null) {
      print("already login.");
      appState.user.addToken(token);
      appState.user.addUserId(userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => new TabScreen()),
      );
    } else {
      //replace it with the login page

      // appState.register.addScreen("info");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Info()),
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => new Login()),
      );
    }
  }

  void navigationPage() {
    // _getCat();
    checkIsLogin();
    // Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        body: Container(
      color: Color(0xff231f20),
      alignment: Alignment.center,
      child: new Image.asset(
        'assets/logo.jpg',
        fit: BoxFit.cover,
      ),
    ));
  }
}







