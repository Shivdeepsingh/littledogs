import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/notifications/followrequest.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificationState();
  }
}

class NotificationState extends State<Notifications> {
  NetworkUtil _networkUtil = NetworkUtil();
  int _length = 0;

  String _image = "";
  List<Widget> _notify() {
    List<Widget> _notification = [];

    _notification.add(Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.amberAccent,
            minRadius: 10,
            maxRadius: 20,
          ),
          SizedBox(
            width: 10,
          ),
          _text()
        ],
      ),
    ));
    _notification.add(Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.amberAccent,
            minRadius: 10,
            maxRadius: 20,
          ),
          SizedBox(
            width: 10,
          ),
          _text()
        ],
      ),
    ));
    _notification.add(Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.amberAccent,
            minRadius: 10,
            maxRadius: 20,
          ),
          SizedBox(
            width: 10,
          ),
          _text()
        ],
      ),
    ));

    return _notification;
  }

  Widget _text() {
    return RichText(
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          new TextSpan(
              text: '#####\t',
              style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: 'Likes your Photo'),
        ],
      ),
    );
  }

  _getFollowRequestList() {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.

    followRequestList, body: {
      "id": appState.user.userId
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      print("dataFollowRequest");
      var extracted = json.decode(value.body);
      dynamic list = extracted['pet_detail'];

      appState.user.followRequestList.clear();
      appState.user.followRequestDetail.clear();

      if (extracted['success'] == true) {
        setState(() {
          _length = list.length;
        });
        for (var data in list) {
          appState.user.followRequestDetail.add(data);
          _image = data['pet_img'];
          appState.otherUser.requestStatus.add(false);
          appState.notifyChange();
        }
        for (var pet in extracted['detail']) {
          appState.user.followRequestList.add(pet);
          appState.notifyChange();
        }
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFollowRequestList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Notifications",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FollowRequest()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, top: 20),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                backgroundColor: Colors.amberAccent,
                                minRadius: 10,
                                maxRadius: 20,
                                backgroundImage: NetworkImage(_image),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.amberAccent,
                                minRadius: 10,
                                maxRadius: 20,
                              ),
                        _length != 0
                            ? Container(
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: Text(
                                  _length.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Follow Requests"),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Approve or ignore requests",
                            style: TextStyle(color: Colors.black38),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              color: Colors.black26,
              width: MediaQuery.of(context).size.width,
              height: 1,
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height / 2,
            //   child: ListView.builder(
            //       itemCount: _notify().length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return _notify()[index];
            //       }),
            // )
          ],
        ),
      ),
    ));
  }
}
