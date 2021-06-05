import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/startup/registration/age.dart';
import 'package:littledog/screens/startup/registration/name.dart';
import 'package:littledog/screens/startup/registration/other.dart';
import 'package:provider/provider.dart';

import 'color.dart';
import 'profilephoto.dart';

class Info extends StatefulWidget {
  // File image;
  // Info({this.image});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InfoState();
  }
}

enum WidgetMarker1 { info, age, color, details, upload }

class InfoState extends State<Info> {
  Widget showScreen(String screen) {
    if (screen == "info") {
      return DogName();
    }
    if (screen == "age") {
      return DogAge();
    }
    if (screen == "color") {
      return DogColor();
    }
    if (screen == "details") {
      return OtherOptions();
    }
    if (screen == "upload") {
      return ProfilePhoto();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
        //  bottomNavigationBar: ,
        body: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 50, bottom: 30),
          child: Text(
            "Registration Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appState.register.screen == "info"
                        ? Color(0xFF1d4695)
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                padding: appState.register.screen == "info"
                    ? EdgeInsets.all(20)
                    : EdgeInsets.all(10),
                child: Text(
                  "1",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: appState.register.screen == "info"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              Container(
                child: Icon(Icons.arrow_right_alt_sharp),
              ),
              Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appState.register.screen == "age"
                        ? Color(0xFF1d4695)
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                padding: appState.register.screen == "age"
                    ? EdgeInsets.all(20)
                    : EdgeInsets.all(10),
                child: Text(
                  "2",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: appState.register.screen == "age"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              Container(
                child: Icon(Icons.arrow_right_alt_sharp),
              ),
              Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appState.register.screen == "color"
                        ? Color(0xFF1d4695)
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                padding: appState.register.screen == "color"
                    ? EdgeInsets.all(20)
                    : EdgeInsets.all(10),
                child: Text(
                  "3",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: appState.register.screen == "color"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              Container(
                child: Icon(Icons.arrow_right_alt_sharp),
              ),
              Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appState.register.screen == "details"
                        ? Color(0xFF1d4695)
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                padding: appState.register.screen == "details"
                    ? EdgeInsets.all(20)
                    : EdgeInsets.all(10),
                child: Text(
                  "4",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: appState.register.screen == "details"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              Container(
                child: Icon(Icons.arrow_right_alt_sharp),
              ),
              Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appState.register.screen == "upload"
                        ? Color(0xFF1d4695)
                        : Colors.white,
                    border: Border.all(color: Colors.black)),
                padding: appState.register.screen == "upload"
                    ? EdgeInsets.all(20)
                    : EdgeInsets.all(10),
                child: Text(
                  "5",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: appState.register.screen == "upload"
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: showScreen(appState.register.screen),
        )
      ]),
    ));
  }
}
