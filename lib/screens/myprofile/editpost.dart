import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/tabscreen.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  String image;
  String text;
  String date;
  int id;
  EditPost({this.image, this.text, this.date, this.id});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditPostState();
  }
}

class EditPostState extends State<EditPost> {
  var textEdit = TextEditingController();

  NetworkUtil _networkUtil = NetworkUtil();

  _updateData() {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.updatePost, body: {
      "post_id": widget.id,
      "post_name": textEdit.text,
      "likes": "2",
      "comments": "afdfdsf",
      "user_id": appState.user.userId
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      print("updateData");
      var extracted = json.decode(value.body);
      if (extracted['success'] == true) {
        appState.user.activeTab = 0;
        appState.user.controller.animateTo(0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new TabScreen()),
        );
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (textEdit.text.isEmpty) {
      textEdit.text = widget.text;
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        title: Text(
          "Edit Info",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.blue,
              ),
              onPressed: () {
                _updateData();
              })
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://static.toiimg.com/thumb/msid-60132235,imgsize-169468,width-800,height-600,resizemode-75/60132235.jpg"),
                          backgroundColor: Colors.amberAccent,
                          minRadius: 10,
                          maxRadius: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Dog Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Container()
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.image,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 0.0, bottom: 10),
                      child: TextFormField(
                        controller: textEdit,
                        validator: (val) =>
                            val.isEmpty ? 'Dog Name can\'t be empty.' : null,
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
            ],
          ),
        ),
      )),
    );
  }
}
