import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:littledog/screens/home/comment.dart';
import 'package:littledog/screens/home/likewidget.dart';
import 'package:littledog/screens/home/videopost.dart';
import 'package:littledog/screens/home/zoomOverlay.dart';

class UserPost extends StatefulWidget {
  String image;
  String petName;
  String postType;
  String post;
  int postId;
  String postName;

  UserPost(
      {this.image,
      this.postId,
      this.post,
      this.petName,
      this.postType,
      this.postName});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserPostState();
  }
}

class UserPostState extends State<UserPost> {
  final FlareControls flareControls = FlareControls();

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
