import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/chat/chatlist.dart';

import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class AddMemberList extends StatefulWidget{

 final int channelId;


  AddMemberList({this.channelId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return AddMemberListState();
  }

}

class AddMemberListState extends State<AddMemberList>{

  NetworkUtil _networkUtil = NetworkUtil();

  bool _loading = false;

  Widget _followList({AppState appState, int index}) {

    bool _exist = false;

    for(var i=0; i<appState.chat.memberList.length; i++){
      if(appState.chat.memberList[i]['created_by'] ==appState.user.followerListDetail[index]['user_id'] ){
        _exist = true;
      }
    }

    if(_exist == true){
      return   Container(
        margin: EdgeInsets.only(left: 17,top: 5),
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            appState.user.followerListDetail[index]['pet_img'] != null
                ? CircleAvatar(
              backgroundColor: Colors.amberAccent,
              minRadius: 10,
              maxRadius: 20,
              backgroundImage: NetworkImage(
                  appState.user.followerListDetail[index]['pet_img']),
            )
                : CircleAvatar(
              backgroundColor: Colors.amberAccent,
              minRadius: 10,
              maxRadius: 20,
            ),
            SizedBox(
              width: 10,
            ),
            appState.user.followerListDetail[index]['name'] != null
                ? Container(
              child: Text(
                appState.user.followerListDetail[index]['name'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
            )
                : Text(""),
          ],
        ),
      );
    }


    return CheckboxListTile(
        title: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              appState.user.followerListDetail[index]['pet_img'] != null
                  ? CircleAvatar(
                backgroundColor: Colors.amberAccent,
                minRadius: 10,
                maxRadius: 20,
                backgroundImage: NetworkImage(
                    appState.user.followerListDetail[index]['pet_img']),
              )
                  : CircleAvatar(
                backgroundColor: Colors.amberAccent,
                minRadius: 10,
                maxRadius: 20,
              ),
              SizedBox(
                width: 10,
              ),
              appState.user.followerListDetail[index]['name'] != null
                  ? Container(
                child: Text(
                  appState.user.followerListDetail[index]['name'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              )
                  : Text(""),
            ],
          ),
        ),
        value: appState.chat.checked[index],
        onChanged: (val) {
          print(val);


          if(val == true){
            appState.chat.groupList.add({
              "name" : appState.user.followerListDetail[index]['name'],
              "image" : appState.user.followerListDetail[index]['pet_img'],
              "userId" : appState.user.followerListDetail[index]['user_id']
            });
          }
          else{
            for(var i=0; i<appState.chat.groupList.length; i++ ){
              if(appState.user.followerListDetail[index]['user_id'] ==appState.chat.groupList[i]['userId'] ){
                appState.chat.groupList.removeAt(i);
              }
            }
          }
          print(appState.chat.groupList);

          // _name = appState.user.followerListDetail[index]['name'];
          // _image =appState.user.followerListDetail[index]['pet_img'];
          // _userId =appState.user.followerListDetail[index]['user_id'];
          setState(
                () {
              appState.chat.checked[index] = val;
            },
          );
        });
  }


  _addMember(int channelId, int authId, AppState appState) {
    setState(() {
      _loading = true;
    });
    _networkUtil.post(Constants.url + Constants.addMember, body: {
      "channel_id": channelId,
      "authID": authId
    }, headers: {
      "Authorization": "Bearar " + appState.user.token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    }).then((value) {
      print(value.body);


      var extracted = json.decode(value.body);

      dynamic data = extracted['response'];


      if(extracted['success'] == true){
        appState.chat.memberList.add(extracted['response']);
        appState.notifyChange();
      //  getDetail(appState: appState, id:data['created_by']);
      }

      setState(() {
        _loading = false;
      });

      print('group Data');
    }).catchError((error) {
      setState(() {
        _loading = false;
      });

      print(error.toString());
    });
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white10,
          title: Text(
            "Add Members",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  for(var i=0; i<appState.chat.groupList.length; i++){
                    _addMember(widget.channelId, appState.chat.groupList[i]['userId'], appState);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatList(
                            )),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 10, right: 10),
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ))
          ],
        ),
        body: Column(
          children: [
            appState.user.followerListDetail.length != 0
                ? Container(
              child: ListView.builder(
                  itemCount: appState.user.followerListDetail.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    return _followList(appState: appState, index: index);
                  }),
            )
                : Container(
              child: Text("No Members"),
            ),
          ],
        ));
  }

}