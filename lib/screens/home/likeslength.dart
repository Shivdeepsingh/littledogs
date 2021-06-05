import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class LikesLength extends StatefulWidget {
  LikesLength(this.postId, this.context);

  int postId;
  BuildContext context;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LikeslengthState();
  }
}

class LikeslengthState extends State<LikesLength> {
  NetworkUtil _networkUtil = NetworkUtil();

  dynamic data = [];

  @override
  void initState() {
    super.initState();
    getLikeList(postId: widget.postId);
  }

  getLikeList({int postId}) {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.likeList, body: {
      "post_id": postId
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
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(left: 10, top: 5),
      alignment: Alignment.topLeft,
      child: Text(
        data.length.toString() + "\tLikes",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
