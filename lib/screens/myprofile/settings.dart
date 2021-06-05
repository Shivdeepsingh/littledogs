import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/screens/settings/about.dart';
import 'package:littledog/screens/settings/currentorder.dart';
import 'package:littledog/screens/settings/help.dart';
import 'package:littledog/screens/settings/privacy.dart';
import 'package:littledog/screens/settings/security.dart';
import 'package:littledog/screens/startup/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => new Login()),
          );
        },
        child: Card(
          elevation: 10,
          color: Colors.black87,
          child: Container(
            width: 40,
            padding: EdgeInsets.all(20),
            //alignment: Alignment.center,
            child: Text(
              "Log Out",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Security()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, top: 30),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.security,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Security",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.black26,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Privacy()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, top: 0.0, bottom: 0.0),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Privacy",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.black26,
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, top: 0.0, bottom: 0.0),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.person_pin,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Account",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.black26,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CurrentOrder()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, top: 0.0, bottom: 0.0),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Current Orders",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.black26,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Help()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, top: 0.0, bottom: 0.0),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.help,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Help",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.black26,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, top: 0.0, bottom: 0.0),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.error,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "About",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
