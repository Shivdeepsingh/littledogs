import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/startup/forgetpassword.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tabscreen.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  var email = TextEditingController();
  var password = TextEditingController();

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  dynamic _user = [];




  NetworkUtil _networkUtil = NetworkUtil();
  bool _showPassword = true;

  bool _loading = false;

  String _deviceToken = "";

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _submit() {
    setState(() {
      _loading = true;
    });
    //  Navigator.pushReplacementNamed(context, '/tabScreen');

    if (validateAndSave()) {
      print("yes");
      print(email.text);
      print(password.text);
      print(Constants.url + Constants.login);
      try {
        _networkUtil.post(Constants.url + Constants.login, body: {
          "email": email.text,
          "password": password.text
        }, headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).then((value) async {
          setState(() {
            _height = 50;
            _loading = false;
          });
          print(value.body);
          var extracted = json.decode(value.body);
          print(extracted['status']);
          print(extracted['token']);

          _user = extracted['user'];
          print(_user["user_id"]);

          final appState = Provider.of<AppState>(context, listen: false);

          if (extracted['success'] == true) {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setString("email", email.text);
            sharedPreferences.setString("token", extracted['token']);
            sharedPreferences.setInt("userId", _user["user_id"]);
            appState.user.addToken(extracted['token']);
            appState.user.addUserId(_user["user_id"]);
            _addDeviceToken(_deviceToken);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => new TabScreen()),
            );
          } else {
            final snackBar = SnackBar(
              content: Text(extracted['message']),
            );
            _scaffoldkey.currentState.showSnackBar(snackBar);
          }
        }).catchError((error) {
          final snackBar = SnackBar(
            content: Text("Server Not Found Try Again later"),
          );
          _scaffoldkey.currentState.showSnackBar(snackBar);
          setState(() {
            _height = 50;
            _loading = false;
          });

          print(error.toString());
        });
      } catch (e) {
        final snackBar = SnackBar(
          content: Text("Server Not Found Try Again later"),
        );
        _scaffoldkey.currentState.showSnackBar(snackBar);
        setState(() {
          _height = 50;
          _loading = false;
        });
        print(e.toString());
      }
    } else {
      print("no");
      setState(() {
        _height = 70;
        _loading = false;
      });
    }
  }

  _addDeviceToken(String token) async {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.deviceToken, body: {
      "user_id": appState.user.userId,
      "user_device_token": token
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    }).then((value) {
      print(value.body);
      print("Device Token Submit Successfully");
    }).catchError((error) {
      print(error.toString());
    });
  }

  double _height = 50;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((String token) {
      assert(token != null);
      setState(() {
        //  _homeScreenText = "Push Messaging token: $token";
      });
      _deviceToken = token;

      print(token);
      print("Device Token");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            height: _height,
                            //   color: Colors.white,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: TextFormField(
                              onTap: () {},
                              controller: email,

                              validator: (val) {
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)) {
                                  return "Enter a valid Email or mobile ";
                                }

                                return null;
                              },
                              // controller: text,
                              // onChanged: _onChanged,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(7.0),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding:
                                      EdgeInsets.only(top: 10, left: 10),
                                  hintText: "Email Id",
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.black26)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            height: _height,
                            //   color: Colors.white,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 0.0, bottom: 10),
                            child: TextFormField(
                              onTap: () {},
                              controller: password,
                              validator: (val) => val.isEmpty
                                  ? 'Password can\'t be empty.'
                                  : null,
                              obscureText: _showPassword ? true : false,
                              // controller: text,
                              // onChanged: _onChanged,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(7.0),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: _showPassword
                                          ? Colors.grey
                                          : Colors.blueAccent,
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(top: 10, left: 10),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.black26)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new ForgetPassword()),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20, top: 10),
                            alignment: Alignment.topRight,
                            child: Text(
                              "Forget password?",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _submit();

                            //   Navigator.pushNamed(context, '/tabScreen');
                          },
                          child: _loading
                              ? Container(
                                  margin: EdgeInsets.only(right: 20, top: 20),
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  width: 150,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(right: 20, top: 20),
                                  alignment: Alignment.center,
                                  color: Color(0xFF0e70be),
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 5, top: 20),
                              alignment: Alignment.topRight,
                              child: Text(
                                "Not a registered user?",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new Register()),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 20, top: 20),
                                alignment: Alignment.topRight,
                                child: Text(
                                  "Register now",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ))),
      ),
    );
  }
}
