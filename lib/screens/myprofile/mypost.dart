import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/home/comment.dart';
import 'package:littledog/screens/home/likewidget.dart';
import 'package:littledog/screens/home/videopost.dart';
import 'package:littledog/screens/home/zoomOverlay.dart';
import 'package:littledog/screens/myprofile/editpost.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

import '../tabscreen.dart';

class MyPost extends StatefulWidget {
  String image;
  String petName;
  String postType;
  String post;
  int postId;
  String postName;

  MyPost(
      {this.image,
      this.postId,
      this.post,
      this.petName,
      this.postType,
      this.postName});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyPostState();
  }
}

class MyPostState extends State<MyPost> {
  final FlareControls flareControls = FlareControls();

  NetworkUtil _networkUtil = NetworkUtil();

  _deletePost({int id, BuildContext context}) {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.deletePost, body: {
      "post_id": id
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);
      if (extracted['success'] == true) {
        appState.user.activeTab = 4;
        appState.user.controller.animateTo(4);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new TabScreen()),
        );
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Posts",
          style: TextStyle(color: Colors.black),
        ),
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
      ),
      body: Container(
        margin: EdgeInsets.only(top: 0.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.image != null
                            ? NetworkImage(widget.image)
                            : AssetImage("assets/noimage.png"),
                        backgroundColor: Colors.amberAccent,
                        minRadius: 10,
                        maxRadius: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: widget.petName != null
                            ? Text(widget.petName,
                                style: TextStyle(fontWeight: FontWeight.bold))
                            : Text(
                                "",
                                // appState.post.feedList[index]['pet_name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      )
                    ],
                  ),
                  Container(
                      width: 25,
                      margin: EdgeInsets.only(right: 10),
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        onSelected: (value) {
                          print(value);
                          if (value == "1") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new EditPost(
                                        image: widget.post,
                                        text: widget.postName,
                                        // date: appState.post.feedList[index]
                                        //     ['createdAt'],
                                        id: widget.postId,
                                      )),
                            );
                          }
                          if (value == "2") {
                            // print(appState.post.feedList[index]['post_id']);
                            _deletePost(id: widget.postId, context: context);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                  fontFamily: "Poppins-Regular", fontSize: 12),
                            ),
                            value: "1",
                          ),
                          PopupMenuItem(
                            value: "2",
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  fontFamily: "Poppins-Regular", fontSize: 12),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () {
                //   flareControls.play("like");
              },
              child: Stack(
                children: [
                  feedType(
                    type: widget.postType,
                    post: widget.post,
                  ),
                  Container(
                    width: double.infinity,
                    height: 250,
                    child: Center(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: FlareActor(
                          'assets/like.flr',
                          controller: flareControls,
                          animation: 'idle',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: LikeWidget(
                postId: widget.postId,
              ),
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    "Dog Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    widget.postName,
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Comments(postId: widget.postId)),
                );
              },
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "View all " +
                      // appState.post.feedList[index]['comments'].length
                      //     .toString() +
                      "\tcomments",
                  style: TextStyle(color: Colors.black26),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget feedType({String type, String post}) {
    if (type == "image") {
      return ZoomOverlay(
          twoTouchOnly: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              margin: EdgeInsets.only(top: 5),
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: post != null
                  ? Image.network(
                      post,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
          ));
    }
    if (type == "video") {
      return VideoPost(
        video: post,
      );
    }

    return Container(
      height: 300,
    );
  }
}
