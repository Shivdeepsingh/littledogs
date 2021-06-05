import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  int postId;

  Comments({this.postId});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommentsState();
  }
}

class CommentsState extends State<Comments> {
  NetworkUtil _networkUtil = NetworkUtil();

  var _comment = TextEditingController();
  dynamic comments = [];

  bool _loading = false;

  _getCommentList() {
    setState(() {
      _loading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.commentList, body: {
      "post_id": widget.postId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      if (extracted['status'] == true) {
        appState.post.commentUser.clear();
        appState.post.commentList.clear();
        _comment.clear();
        if (extracted['comments_user'].length != 0) {
          for (var comment in extracted['comments_user']) {
            print(comment);
            appState.post.commentUser.add(comment);
          }

          for (var commentData in extracted['comments']) {
            appState.post.commentList.add(commentData);
          }
        }
      }

      setState(() {
        _loading = false;
      });

      print("data comments");
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      print(error.toString());
    });
  }

  Widget _comments(BuildContext context, int index, AppState appState) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          appState.post.commentUser[index] != null
              ? CircleAvatar(
                  backgroundColor: Colors.amberAccent,
                  minRadius: 10,
                  maxRadius: 20,
                  backgroundImage:
                      appState.post.commentUser[index]['pet_img'] != null
                          ? NetworkImage(
                              appState.post.commentUser[index]['pet_img'])
                          : AssetImage("assets/noimage.png"),
                )
              : Container(),
          SizedBox(
            width: 10,
          ),
          appState.post.commentUser[index] != null
              ? Container(
                  child: Text(
                    appState.post.commentUser[index]['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                )
              : Container(),
          SizedBox(
            width: 10,
          ),
          commentData(index, appState)
        ],
      ),
    );
  }

  Widget commentData(int index, AppState appState) {
    return Container(
      child: Text(appState.post.commentList[index]['comments']),
    );
  }

  _addComment() async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.addComment, body: {
      "comments": _comment.text,
      "post_id": widget.postId,
      "user_id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);
      comments = extracted['response'];

      if (extracted['success'] == true) {
        appState.post.commentUser.add({
          "name": appState.petDetails.dogName,
          "pet_img": appState.petDetails.image
        });

        appState.post.commentList.add({"comments": _comment.text});
        appState.notifyChange();
        _comment.clear();
        print("add Comment Successfully");
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCommentList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Comments",
            style: TextStyle(color: Colors.black),
          ),
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
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //  alignment: Alignment.bottomCenter,
            children: [
              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      //height: MediaQuery.of(context).size.height / 1.2,
                      child: appState.post.commentUser.length != 0
                          ? ListView.builder(
                              itemCount: appState.post.commentUser.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return _comments(context, index, appState);
                              })
                          : Center(
                              child: Text("No Comments Yet"),
                            ),
                    ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.amberAccent,
                      minRadius: 10,
                      maxRadius: 20,
                    ),
                    Flexible(
                      child: Container(
                        height: 30,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0.0, bottom: 10),
                        child: TextFormField(
                          controller: _comment,
                          decoration: InputDecoration(
                            fillColor: Colors.white10,
                            filled: true,
                            hintText: "Enter Comment",
                            hintStyle: TextStyle(color: Colors.black26),
                            contentPadding:
                                EdgeInsets.only(top: 0.0, left: 10, bottom: 10),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _addComment();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
