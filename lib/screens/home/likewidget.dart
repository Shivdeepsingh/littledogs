import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/home/comment.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class LikeWidget extends StatefulWidget {
  int postId;
  String image;

  LikeWidget({this.postId, this.image});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LikeWidgetState();
  }
}

class LikeWidgetState extends State<LikeWidget> {
  bool _liked = false;

  NetworkUtil _networkUtil = NetworkUtil();

  int likeId;
  dynamic data = [];

  @override
  void initState() {
    super.initState();
    _getLike(context: context);
    getLikeList();
  }

  _getLike({BuildContext context}) {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.userLikes, body: {
      "post_id": widget.postId,
      "user_id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      if (extracted['isAuthLike'] == true) {
        setState(() {
          _liked = true;
        });

        for (var data in extracted['likeUserPost']['rows']) {
          likeId = data['like_id'];
        }

        appState.notifyChange();

        for (var data in extracted['likeUserPost']['rows']) {
          likeId = data['like_id'];
        }
      } else {
        setState(() {
          _liked = false;
        });
      }

      print("Like Status");
    }).catchError((error) {
      print(error.toString());
    });
  }

  _addLike({int postId, BuildContext context}) async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.addLike, body: {
      "likes": 1,
      "post_id": postId,
      "user_id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        //    LikesLength(postId, context);
        likeId = extracted['response']['like_id'];
        print("add Like Successfull");
      }
    }).catchError((error) {
      print(error);
    });
  }

  _deleteLike({int likeId, BuildContext context}) async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.deleteLike, body: {
      "like_id": likeId,
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);
      if (extracted['success'] == true) {
        //    LikesLength(widget.postId, context);
        // LikesLength(widget.postId);
        print("Delete Like Successfull");
      }
    }).catchError((error) {
      print(error);
    });
  }

  getLikeList() {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.likeList, body: {
      "post_id": widget.postId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      if (extracted['status'] == true) {
        data = extracted['likes_user'];
        print(data.length);
        print("data Length");
        setState(() {});
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                if (_liked == true) {
                  print("likeIdUser");
                  print(likeId);
                  data.length = data.length - 1;
                  _deleteLike(likeId: likeId, context: context);
                }
                if (_liked == false) {
                  data.length = data.length + 1;
                  _addLike(postId: widget.postId, context: context);
                }
                setState(() {
                  _liked = !_liked;
                });

                print("indexPost");
              },
              child: Container(
                child: _liked
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 30,
                      )
                    : Icon(
                        Icons.favorite_border,
                        size: 30,
                      ),
                margin: EdgeInsets.only(left: 10, top: 5),
              ),
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
                margin: EdgeInsets.only(left: 10, top: 8),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 27,
                ),
                // child: Image.asset(
                //   "assets/comment.png",
                //   width: 30,
                //   height: 30,
                // ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (Platform.isAndroid) {
                  var url = widget.image;
                  var response = await get(Uri.parse(url));
                  final documentDirectory =
                      (await getExternalStorageDirectory()).path;
                  File imgFile = new File('$documentDirectory/flutter.png');
                  imgFile.writeAsBytesSync(response.bodyBytes);
                  Share.shareFiles(['$documentDirectory/flutter.png'],
                      subject: '', text: '');
                } else {
                  Share.share('Hello, check your share files!',
                      subject: 'URL File Share');
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 0.0),
                child: Icon(
                  Icons.share_sharp,
                  size: 25,
                ),
                // child: Image.asset(
                //   "assets/share.png",
                //   width: 30,
                //   height: 30,
                // ),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 5),
          alignment: Alignment.topLeft,
          child: Text(
            data.length.toString() + "\tLikes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        )
      ],
    );
  }
}
