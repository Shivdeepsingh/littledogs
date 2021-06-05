import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class LikeList extends StatefulWidget {
  int postId;

  LikeList(this.postId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LikeListState();
  }
}

class LikeListState extends State<LikeList> {
  NetworkUtil _networkUtil = NetworkUtil();

  dynamic list = [];

  bool _loading = false;

  _getLikeList() {
    setState(() {
      _loading = true;
    });
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

      // list = extracted['likes_user'];

      if (extracted['status'] == true) {
        appState.post.likeList.clear();
        for (var data in extracted['likes_user']) {
          appState.post.likeList.add(data);
          appState.notifyChange();
        }
      }

      setState(() {
        _loading = false;
      });

      print("data");
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      print(error.toString());
    });
  }

  List<Widget> _likeList() {
    List<Widget> _like = [];

    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.post.likeList.length != null) {
      for (var data in appState.post.likeList) {
        //   print(data);
        _like.add(Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              data['pet_img'] != null
                  ? CircleAvatar(
                      backgroundColor: Colors.amberAccent,
                      minRadius: 10,
                      maxRadius: 20,
                      backgroundImage: NetworkImage(data['pet_img']),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.amberAccent,
                      minRadius: 10,
                      maxRadius: 20,
                    ),
              SizedBox(
                width: 10,
              ),
              data['name'] != null
                  ? Container(
                      child: Text(
                        data['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )
                  : Text(""),
            ],
          ),
        ));
      }
    }

    return _like;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLikeList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white10,
          title: Text(
            "Likes",
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
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              )
            : Container(
                child: _likeList().length != 0
                    ? Container(
                        child: ListView.builder(
                            itemCount: _likeList().length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10),
                            itemBuilder: (BuildContext context, int index) {
                              return _likeList()[index];
                            }),
                      )
                    : Container(
                        child: Text("No Likes Yet"),
                      ),
              ));
  }
}
