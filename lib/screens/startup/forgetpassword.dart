import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ForgetPasswrdState();
  }
}

class ForgetPasswrdState extends State<ForgetPassword> {
  final formKey = new GlobalKey<FormState>();
  NetworkUtil _networkUtil = NetworkUtil();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _loading = false;

  var email = TextEditingController();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _forgetPassword() {
    if (validateAndSave()) {
      setState(() {
        height = 50;
        _loading = true;
      });
      try {
        _networkUtil.post(Constants.url + Constants.forgetPassword, body: {
          "email": email.text,
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
            final snackBar = SnackBar(
              content: Text(extracted['message']),
            );

            _scaffoldKey.currentState.showSnackBar(snackBar);
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
                      "Forget Password",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _forgetPassword();
                          //  _register();
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
