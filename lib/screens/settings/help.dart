import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';

class Help extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HelpState();
  }
}

class HelpState extends State<Help> {
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  NetworkUtil _networkUtil = NetworkUtil();

  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var description = TextEditingController();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _submit() {
    if (validateAndSave()) {
      print("yes");
      try {
        _networkUtil.post(Constants.url + Constants.contact, body: {
          "name": name.text,
          "email": email.text,
          "contact_no": phone.text,
          "msg": description.text
        }, headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).then((value) async {
          print(value.body);
          var extracted = json.decode(value.body);
          print(extracted['status']);

          if (extracted['success'] == true) {
            final snackBar = SnackBar(
              content: Text(extracted['message']),
            );
            _scaffoldkey.currentState.showSnackBar(snackBar);
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

          print(error.toString());
        });
      } catch (e) {
        final snackBar = SnackBar(
          content: Text("Server Not Found Try Again later"),
        );
        _scaffoldkey.currentState.showSnackBar(snackBar);

        print(e.toString());
      }
    } else {
      print("no");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
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
          "Help",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, left: 30, bottom: 0.0),
              alignment: Alignment.topLeft,
              child: Text("Name"),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 70,
                    //   color: Colors.white,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 0.0, bottom: 10),
                    child: TextFormField(
                      controller: name,
                      validator: (val) =>
                          val.isEmpty ? 'Name can\'t be empty.' : null,
                      // onChanged: _onChanged,
                      decoration: InputDecoration(
                        fillColor: Colors.white10,
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 30, bottom: 0.0),
              alignment: Alignment.topLeft,
              child: Text("Email Address"),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 70,
                    //   color: Colors.white,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 0.0, bottom: 10),
                    child: TextFormField(
                      controller: email,
                      validator: (val) {
                        if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)) {
                          return "Enter a valid Email or mobile ";
                        }

                        return null;
                      },
                      // onChanged: _onChanged,
                      decoration: InputDecoration(
                        fillColor: Colors.white10,
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 30, bottom: 0.0),
              alignment: Alignment.topLeft,
              child: Text("Phone Number"),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 70,
                    //   color: Colors.white,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 0.0, bottom: 10),
                    child: TextFormField(
                      controller: phone,
                      validator: (val) =>
                          val.isEmpty ? 'Phone Number can\'t be empty.' : null,
                      //   maxLines: 5,
                      // onChanged: _onChanged,
                      decoration: InputDecoration(
                        fillColor: Colors.white10,
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 30, bottom: 0.0),
              alignment: Alignment.topLeft,
              child: Text("Description"),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 100,
                    //   color: Colors.white,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 0.0, bottom: 10),
                    child: TextFormField(
                      controller: description,
                      validator: (val) =>
                          val.isEmpty ? 'Description can\'t be empty.' : null,
                      maxLines: 5,
                      // onChanged: _onChanged,
                      decoration: InputDecoration(
                        fillColor: Colors.white10,
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                _submit();

                //   Navigator.pushNamed(context, '/tabScreen');
              },
              child: Container(
                width: 150,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 20, top: 40),
                alignment: Alignment.center,
                color: Color(0xFF0e70be),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
