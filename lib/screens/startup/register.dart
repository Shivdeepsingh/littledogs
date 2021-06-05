import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

import 'registration/otpscreen.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();
  NetworkUtil _networkUtil = NetworkUtil();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _loading = false;

  bool _showPassword = true;
  var email = TextEditingController();
  var password = TextEditingController();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _register() {
    if (validateAndSave()) {
      setState(() {
        height = 50;
        _loading = true;
      });
      try {
        _networkUtil.post(Constants.url + Constants.register, body: {
          "email": email.text,
          "password": password.text
        }, headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).then((value) {
          print(value.body);
          setState(() {
            _loading = false;
          });
          var extracted = json.decode(value.body);
          if (extracted['success'] == true) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OTPScreen()),
            );
          } else {
            final snackBar = SnackBar(
              content: Text(extracted['message']),
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
        }).catchError((error) {
          setState(() {
            _loading = false;
          });
          print(error.toString());
        });
      } catch (e) {
        setState(() {
          _loading = false;
        });
        print(e.toString());
      }
    } else {
      setState(() {
        height = 70;
        _loading = false;
      });
    }
  }

  double height = 50;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      "Register",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          height: height,
                          //   color: Colors.white,
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: TextFormField(
                            controller: email,
                            validator: (val) {
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)) {
                                return "Enter a valid Email or mobile ";
                              }

                              return null;
                            },
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
                          height: height,
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => OTPScreen()),
                          // );
                          _register();
                        },
                        child: _loading
                            ? CircularProgressIndicator()
                            : Container(
                                width: 150,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    right: 0.0, top: 20, bottom: 30),
                                alignment: Alignment.center,
                                color: Color(0xFF0e70be),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
