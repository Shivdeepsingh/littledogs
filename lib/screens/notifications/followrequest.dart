import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

import '../home/otheruser/userProfile.dart';

class FollowRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FollowRequestState();
  }
}

class FollowRequestState extends State<FollowRequest> {
  NetworkUtil _networkUtil = NetworkUtil();

  _addRequest({int requestId, int index}) async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.followRequestAccept, body: {
      "follow_request_id": requestId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        appState.otherUser.requestStatus[index] = true;
        appState.notifyChange();
        print("add Follow Successfully");
      }
    }).catchError((error) {
      print(error);
    });
  }

  Widget _requestList(BuildContext context, int index, AppState appState) {
    // if (appState.user.followRequestList[index]['follow_request_status'] ==
    //     "1") {
    //   return Container();
    // }
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(
                          userId: appState.user.followRequestList[index]
                              ['from_user_id'],
                        )),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: appState.user.followRequestDetail[index]
                              ['pet_img'] !=
                          null
                      ? NetworkImage(
                          appState.user.followRequestDetail[index]['pet_img'])
                      : null,
                  backgroundColor: Colors.amberAccent,
                  minRadius: 10,
                  maxRadius: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child:
                      appState.user.followRequestDetail[index]['name'] != null
                          ? Text(
                              appState.user.followRequestDetail[index]['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(""),
                )
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (appState.otherUser.requestStatus[index] == false) {
                    _addRequest(
                        requestId: appState.user.followRequestList[index]
                            ['follow_request_id'],
                        index: index);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: appState.otherUser.requestStatus[index]
                      ? Colors.white
                      : Colors.blue,
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                        color: appState.otherUser.requestStatus[index]
                            ? Colors.black
                            : Colors.white,
                        fontSize: 15),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Follow Requests",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: appState.user.followRequestList.length != 0
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemCount: appState.user.followRequestList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _requestList(context, index, appState);
                })
            : Center(
                child: Text("No Requests"),
              ),
      ),
    );
  }
}
