import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/myprofile/followerList.dart';
import 'package:littledog/screens/myprofile/mainprofilevideo.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

import 'Followinglist.dart';
import 'editprofile.dart';
import 'mypost.dart';
import 'settings.dart';

class MainProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainProfileState();
  }
}

class MainProfileState extends State<MainProfile>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TabController _controller;
  NetworkUtil _networkUtil = NetworkUtil();

  List<Map<String, dynamic>> _postImage = [];
  List<Map<String, dynamic>> _postVideo = [];

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _petDetails();
  }

  _petDetails() async {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.petDetails, body: {
      "user_id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      var extracted = json.decode(value.body);
      dynamic _details = extracted['pet_detail'];

      if (extracted['message'] == "Pet_detail") {
        appState.petDetails.addPetId(_details["pet_id"]);
        appState.petDetails.addDogName(_details["name"]);
        appState.petDetails.addImage(_details["pet_img"]);
        appState.petDetails.addDogBreed(_details["breed"]);
        appState.petDetails.addDogColor(_details["color"]);
        appState.petDetails.addGender(_details["gender"]);
        appState.petDetails.addDogAge(_details['dob']);
        appState.petDetails.addConcern(_details['health_concerns']);
        appState.notifyChange();

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
          // _story.add(story);
        }

        if (mounted) {
          setState(() {});
        }
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.petDetails.dogName);
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        title: Text(
          "My Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
        ],
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
                        backgroundImage: appState.petDetails.image == null
                            ? NetworkImage(
                                "https://p.kindpng.com/picc/s/49-496597_dog-png-fluffy-teacup-pomeranian-white-background-transparent.png")
                            : NetworkImage(appState.petDetails.image),
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
                              appState.user.followerList.length != 0
                                  ? Text(
                                      appState.user.followerList.length
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
                              appState.user.followingList.length != 0
                                  ? Text(
                                      appState.user.followingList.length
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
                  child: appState.petDetails.dogName != null
                      ? Text(
                          appState.petDetails.dogName.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      : Text(""),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, left: 20),
                  alignment: Alignment.topLeft,
                  child: appState.petDetails.dogBreed.isNotEmpty
                      ? Text(appState.petDetails.dogBreed)
                      : Text(""),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(null),
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(5)),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text("Edit Profile"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                new Container(
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
                ),
                new Container(
                  height: MediaQuery.of(context).size.height / 2.0,
                  child: new TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                      print(_postImage[index]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyPost(
                                                  petName: appState
                                                      .petDetails.dogName,
                                                  postId: _postImage[index]
                                                      ['post_id'],
                                                  post: _postImage[index]
                                                      ['post'],
                                                  postName: _postImage[index]
                                                      ['post_name'],
                                                  postType: _postImage[index]
                                                      ['post_type'],
                                                  image:
                                                      appState.petDetails.image,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black26),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              _postImage[index]['post']),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "https://p.kindpng.com/picc/s/49-496597_dog-png-fluffy-teacup-pomeranian-white-background-transparent.png"),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                );
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
                                      print(_postVideo[index]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyPost(
                                                  petName: appState
                                                      .petDetails.dogName,
                                                  postId: _postVideo[index]
                                                      ['post_id'],
                                                  post: _postVideo[index]
                                                      ['post'],
                                                  postName: _postVideo[index]
                                                      ['post_name'],
                                                  postType: _postVideo[index]
                                                      ['post_type'],
                                                  image:
                                                      appState.petDetails.image,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black26),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: MainProfileVideo(
                                          _postVideo[index]['post']),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "https://p.kindpng.com/picc/s/49-496597_dog-png-fluffy-teacup-pomeranian-white-background-transparent.png"),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
