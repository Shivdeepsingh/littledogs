import 'package:flutter/material.dart';
import 'package:littledog/modals/register.dart';
import 'package:littledog/screens/home/home.dart';
import 'package:littledog/screens/startup/login.dart';
import 'package:littledog/screens/startup/splashscreen.dart';
import 'package:littledog/screens/tabscreen.dart';






class Routes {
  static final routes = {
    '/': (BuildContext context) => SplashScreen(),
    '/login': (BuildContext context) => Login(),
    '/register': (BuildContext context) => Register(),
    '/home': (BuildContext context) => Home(),
    '/tabScreen': (BuildContext context) => TabScreen(),
  };

  static MaterialPageRoute generateRoute(RouteSettings settings) {
    final List<String> path = settings.name.split('/');

    if (path[0] != '') return null;
    if (path[1] == 'otpregister') {
      // this is not needed here yet
    }

    return null;
  }

  static MaterialPageRoute unknownRoute(RouteSettings settings) {
    print("Router: " + settings.name + ' is not defined.');

    return null;
  }
}
