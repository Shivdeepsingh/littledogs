import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/chat/chatscreen.dart';
import 'package:littledog/screens/chat/groupchatlist.dart';
import 'package:littledog/screens/chat/groupchatscreen.dart';
import 'package:littledog/screens/tabscreen.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatListState();
  }
}

class ChatListState extends State<ChatList> {
  NetworkUtil _networkUtil = NetworkUtil();

  List<Widget> _chat = [];

  // SocketIO socketIO;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getChatList();
  }

  _getChatList() {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.getChannelList, body: {
      "authID": appState.user.userId
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      print("chat List");
      appState.chat.chatList.clear();
      appState.chat.chatDetail.clear();
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        for (var data1 in extracted['response']) {
          appState.chat.chatDetail.add(data1);
          appState.notifyChange();
        }

        for (var i = 0; i < appState.chat.chatDetail.length; i++) {
          if (appState.chat.chatDetail[i]['is_private'] == true) {
            print(appState.chat.chatDetail[i]);

            try {
              _networkUtil.post(Constants.url + Constants.petDetails, body: {
                "user_id": appState.chat.chatDetail[i]['receiver_id']
              }, headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                "Authorization": "Bearar " + appState.user.token
              }).then((value) {
                print(value.body);
                var extracted = json.decode(value.body);
                dynamic _list = extracted['pet_detail'];

                print("Pet Details");

                if (extracted['message'] == "Pet_detail") {
                  appState.chat.chatDetail[i]['name'] = _list['name'];
                  appState.chat.chatDetail[i]['icon'] = _list['pet_img'];

                  appState.notifyChange();
                }
                print("petDetails");
              }).catchError((error, s) {
                print(s.toString());
              });
            } catch (e) {
              print(e.toString());
            }
          }
        }
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  Widget petDetails(AppState appState, int index) {
    print(appState.user.userId);
    return GestureDetector(
      onLongPress: () {
        _bottomSheet(appState.chat.chatDetail[index]['receiver_id']);
      },
      onTap: () {
        print(appState.chat.chatDetail[index]['icon']);
        print("fkjdhfjfh");
        if (appState.chat.chatDetail[index]['is_private'] == true) {
          //  appState.chat.chatMessage.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      recieverId: appState.chat.chatDetail[index]
                          ['receiver_id'],
                      senderId: appState.user.userId,
                      name: appState.chat.chatDetail[index]["name"],
                      image: appState.chat.chatDetail[index]["icon"],
                      channelId: appState.chat.chatDetail[index]['group_id'],
                    )),
          );
        } else {
          //  appState.chat.chatMessage.clear();
          print("group");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupChatScreen(
                      recieverId: appState.chat.chatDetail[index]
                          ['receiver_id'],
                      senderId: appState.user.userId,
                      name: appState.chat.chatDetail[index]["name"],
                      image: appState.chat.chatDetail[index]["icon"],
                      channelId: appState.chat.chatDetail[index]['group_id'],
                    )),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.amberAccent,
                    backgroundImage: appState.chat.chatDetail[index]['icon'] !=
                            null
                        ? NetworkImage(appState.chat.chatDetail[index]['icon'])
                        : AssetImage("assets/noimage.png"),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          appState.chat.chatDetail.length != 0
                              ? Text(
                                  appState.chat.chatDetail[index]['name'],
                                  style: TextStyle(fontSize: 16),
                                )
                              : Text(""),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _deleteUser({int recieverId}) {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.deleteUser, body: {
      "sender_id": appState.user.userId,
      "receiver_id": recieverId
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      print("chat List");
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        for (var i = 0; i < appState.chat.chatDetail.length; i++) {
          if (appState.chat.chatDetail[i]['receiver_id'] == recieverId) {
            appState.chat.chatDetail.removeAt(i);
            appState.notifyChange();

          }
        }
        Navigator.of(context, rootNavigator: true).pop();
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  _bottomSheet(int reciever_Id) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 60,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              margin: const EdgeInsets.only(
                  top: 5, left: 0.0, right: 0.0, bottom: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      print("reciverId $reciever_Id");
                      _deleteUser(recieverId: reciever_Id);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.delete_forever),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 20, right: 10, bottom: 10.0),
                            child: Text(
                              "Delete",
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          title: Text(
            "Messages",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new TabScreen()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.group_add,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                appState.chat.groupList.clear();
                appState.chat.groupDetail.clear();
                appState.chat.checked.clear();

                for (var data in appState.user.followerList) {
                  appState.chat.checked.add(false);
                  appState.notifyChange();
                }

                print("checkedList ${appState.chat.checked}");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupChatList()),
                );
                // Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: appState.chat.chatDetail.length != 0
            ? ListView.builder(
                itemCount: appState.chat.chatDetail.length,
                shrinkWrap: true,
                reverse: false,
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return petDetails(appState, index);
                })
            : Container());
  }
}
