import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/chat/chatscreen.dart';
import 'package:littledog/screens/home/otheruser/Followinglist.dart';
import 'package:littledog/screens/home/otheruser/followerList.dart';
import 'package:littledog/screens/home/otheruser/userpost.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final int userId;

  UserProfile({this.userId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TabController _controller;
  NetworkUtil _networkUtil = NetworkUtil();

  List<Map<String, dynamic>> _postImage = [];
  List<Map<String, dynamic>> _postVideo = [];
  List<Map<String, dynamic>> _story = [];

  dynamic _list = [];

  bool _follow1 = false;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _petDetails();
    _followerList();
    _followingList();
  }

  _petDetails() async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.petDetails, body: {
      "user_id": widget.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);
      _list = extracted['pet_detail'];

      print("Pet Details");

      _postImage.clear();
      _postVideo.clear();

      if (extracted['message'] == "Pet_detail") {
        appState.otherUser.addPetId(_list["pet_id"]);
        appState.otherUser.addDogName(_list["name"]);
        appState.otherUser.addImage(_list["pet_img"]);
        appState.otherUser.addDogBreed(_list["breed"]);
        appState.otherUser.addDogColor(_list["color"]);
        appState.otherUser.addGender(_list["gender"]);
        appState.otherUser.addDogAge(_list['dob']);
        appState.otherUser.addConcern(_list['health_concerns']);

        for (var post in extracted['Post_detail']) {
          if (post['post_type'] == "image") {
            _postImage.add(post);
          }
          if (post['post_type'] == "video") {
            _postVideo.add(post);
            appState.notifyChange();
          }
        }

        for (var story in extracted['Story_Post_detail']) {
          _story.add(story);
        }

        setState(() {});
        appState.notifyChange();
      }

      print("petDetails");
    }).catchError((error, s) {
      print(s.toString());
    });
  }

  _sendFollowRequest() {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.addFollow, body: {
      "from_user_id": appState.user.userId,
      "to_user_id": widget.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      dynamic response = extracted['response'];

      if (extracted['success'] == true) {
        setState(() {
          appState.otherUser.addRequestId(response['follow_request_id']);
          appState.user.requestSend = true;
        });
      } else {
        setState(() {
          appState.user.requestSend = false;
        });
      }

      print("Send Follow Request");
    }).catchError((error, s) {
      print(s.toString());
    });
  }

  _deleteFollowRequest() {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    print(appState.otherUser.requestId);

    _networkUtil.post(Constants.url + Constants.deleteFollow, body: {
      "follow_request_id": appState.otherUser.requestId,
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        setState(() {
          appState.user.requestSend = false;
        });
      } else {
        setState(() {
          appState.user.requestSend = true;
        });
      }

      print("Delete Follow Request");
    }).catchError((error, s) {
      print(s.toString());
    });
  }

  _followingList() async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.followingList, body: {
      "id": widget.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);
      //   _details = extracted['detail'];
      appState.otherUser.followingList.clear();
      appState.otherUser.followingListDetail.clear();
      if (extracted['status'] == true) {
        for (var data in extracted['detail']) {
          appState.otherUser.followingList.add(data);
          appState.notifyChange();
        }
        for (var petData in extracted['user_data']) {
          appState.otherUser.followingListDetail.add(petData);
          appState.notifyChange();
        }
      }
      print("followingList");
    }).catchError((error, s) {
      print(s.toString());
    });
  }

  _followerList() async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.followerList, body: {
      "id": widget.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);
      // _details = extracted['detail'];
      appState.otherUser.followerList.clear();
      appState.otherUser.followerListDetail.clear();
      if (extracted['success'] == true) {
        for (var data in extracted['detail']) {
          appState.otherUser.followerList.add(data);
          appState.notifyChange();
        }
        for (var petData in extracted['pet_detail']) {
          appState.otherUser.followerListDetail.add(petData);
          appState.notifyChange();
        }
      }
      print("followList");
    }).catchError((error, s) {
      print(s.toString());
    });
  }

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
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: appState.otherUser.dogName != null
            ? Text(
                appState.otherUser.dogName,
                style: TextStyle(color: Colors.black),
              )
            : Text(""),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 0.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.pinkAccent, width: 2)),
                      child: CircleAvatar(
                        backgroundImage: appState.otherUser.image == null
                            ? NetworkImage(
                                "https://p.kindpng.com/picc/s/49-496597_dog-png-fluffy-teacup-pomeranian-white-background-transparent.png")
                            : NetworkImage(appState.otherUser.image),
                        maxRadius: 45,
                        minRadius: 35,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              (_postImage.length + _postVideo.length)
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              "Post",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowerList(),
                                ));
                          },
                          child: Column(
                            children: [
                              appState.otherUser.followerList.length != 0
                                  ? Text(
                                      appState.otherUser.followerList.length
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                  : Text(
                                      "0",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                              Text(
                                "Followers",
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowingList(),
                                ));
                          },
                          child: Column(
                            children: [
                              appState.otherUser.followingList.length != 0
                                  ? Text(
                                      appState.otherUser.followingList.length
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                  : Text(
                                      "0",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                              Text(
                                "Following",
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  alignment: Alignment.topLeft,
                  child: appState.otherUser.dogName != null
                      ? Text(
                          appState.otherUser.dogName.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      : Text(""),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, left: 20),
                  alignment: Alignment.topLeft,
                  child: appState.otherUser.dogBreed.isNotEmpty
                      ? Text(appState.otherUser.dogBreed)
                      : Text(""),
                ),
                appState.user.showData
                    ? GestureDetector(
                        onTap: () {
                          print(appState.otherUser.dogName);
                          print(appState.otherUser.image);
                          print("shhjkshjfj");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      recieverId: widget.userId,
                                      senderId: appState.user.userId,
                                      name: appState.otherUser.dogName,
                                      image: appState.otherUser.image,
                                    )),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "Message",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Container(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      appState.user.requestSend = !appState.user.requestSend;
                    });

                    if (appState.user.requestSend == false) {
                      print("delete");
                      _deleteFollowRequest();
                    }

                    if (appState.user.requestSend == true) {
                      _sendFollowRequest();
                      print("requested");
                    }
                  },
                  child: appState.user.showData
                      ? Container()
                      : Container(
                          child: appState.user.requestSend
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 20),
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                    "Requested",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 20),
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                    "Follow",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                ),
                SizedBox(
                  height: 10,
                ),
                appState.user.showData
                    ? new Container(
                        decoration: new BoxDecoration(color: Colors.white),
                        child: new TabBar(
                          controller: _controller,
                          tabs: [
                            new Tab(
                              icon: const Icon(
                                Icons.photo,
                                color: Colors.black,
                              ),
                            ),
                            new Tab(
                              icon: const Icon(
                                Icons.video_call,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                appState.user.showData
                    ? new Container(
                        height: MediaQuery.of(context).size.height / 2.0,
                        child: new TabBarView(
                          controller: _controller,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                // height: MediaQuery.of(context).size.height / 1.9,
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  shrinkWrap: true,
                                  children: List.generate(
                                    _postImage.length,
                                    (index) {
                                      if (_postImage.length != 0) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserPost(
                                                        petName: appState
                                                            .otherUser.dogName,
                                                        postId:
                                                            _postImage[index]
                                                                ['post_id'],
                                                        post: _postImage[index]
                                                            ['post'],
                                                        postName:
                                                            _postImage[index]
                                                                ['post_name'],
                                                        postType:
                                                            _postImage[index]
                                                                ['post_type'],
                                                        image: appState
                                                            .otherUser.image,
                                                      )),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black26),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      _postImage[index]
                                                          ['post']),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                // height: MediaQuery.of(context).size.height / 1.9,
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  shrinkWrap: true,
                                  children: List.generate(
                                    _postVideo.length,
                                    (index) {
                                      if (_postVideo.length != 0) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserPost(
                                                        petName: appState
                                                            .otherUser.dogName,
                                                        postId:
                                                            _postVideo[index]
                                                                ['post_id'],
                                                        post: _postVideo[index]
                                                            ['post'],
                                                        postName:
                                                            _postVideo[index]
                                                                ['post_name'],
                                                        postType:
                                                            _postVideo[index]
                                                                ['post_type'],
                                                        image: appState
                                                            .otherUser.image,
                                                      )),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black26),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      _postVideo[index]
                                                          ['post']),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                )),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
