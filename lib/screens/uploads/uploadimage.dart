import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/home/home.dart';
import 'package:littledog/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


import '../tabscreen.dart';

class UploadImage extends StatefulWidget {
  File post;
  String value;
  String type;

  UploadImage({this.post, this.value, this.type});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UploadImageState();
  }
}

class UploadImageState extends State<UploadImage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var text = TextEditingController();
  bool _loading = false;
  dynamic data = [];
  TabController controller;

  VideoPlayerController playerController;
  VoidCallback listener;

  void initializeVideo() async {
    try {
      playerController = VideoPlayerController.file(widget.post)
        ..addListener(listener)
        ..setVolume(0.0)
        ..initialize()
        ..setLooping(true)
        ..play();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (playerController != null) playerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listener = () {
      setState(() {});
    };
    initializeVideo();
  }

  _addPost({BuildContext context}) async {
    setState(() {
      _loading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);

    // open a bytestream
    print(widget.post.path);
    var stream =
        new http.ByteStream(DelegatingStream.typed(widget.post.openRead()));
    // get file length
    var length = await widget.post.length();
    // string to uri
    var uri = Uri.parse(Constants.url + Constants.addPost);
    print(uri);
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('post', stream, length,
        filename: widget.post.path.split('/').last);

    // add file to multipart
    request.files.add(multipartFile);
    print(multipartFile.filename);
    request.fields.addAll({
      "post_name": text.text,
      "post_type": widget.type,
      "user_id": appState.user.userId.toString(),
    });

    request.headers.addAll({
      "Authorization": "Bearar " + appState.user.token,
    });
    // send
    var response = await request.send();
    print(response.statusCode);
    print("jdjfhkjsdfh");

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      Map<String, dynamic> user = jsonDecode(value);
      print("data" + user['message']);
      print("sdsjd");
      if (user['success'] == true) {
        if (widget.value == "gallery") {
          appState.user.activeTab = 0;
          appState.user.controller.animateTo(0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => new TabScreen()),
          );
          final snackBar = SnackBar(
            content: Text(user['message']),
          );
          _scaffoldkey.currentState.showSnackBar(snackBar);
        }
        if (widget.value == "camera") {
          appState.user.activeTab = 0;
          appState.user.controller.animateTo(0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => new Home()),
          );
          final snackBar = SnackBar(
            content: Text(user['message']),
          );
          _scaffoldkey.currentState.showSnackBar(snackBar);
        }
        if (widget.value == "video") {
          appState.user.activeTab = 0;
          appState.user.controller.animateTo(0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => new Home()),
          );
          final snackBar = SnackBar(
            content: Text(user['message']),
          );
          _scaffoldkey.currentState.showSnackBar(snackBar);
        }
      } else {
        final snackBar = SnackBar(
          content: Text(user['message']),
        );
        _scaffoldkey.currentState.showSnackBar(snackBar);
      }

      print("sdsjd");
      setState(() {
        _loading = false;
      });
    }).onError((error) {
      print(error);
      setState(() {
        _loading = false;
      });
      print("sdsjd");
    });
  }

  Widget postType(String type, File post) {
    if (type == "image") {
      return Container(
        height: 300,
        width: 250,
        child: Image.file(widget.post),
      );
    }
    if (type == "video") {
      return Container(
          alignment: Alignment.center,
          height: 300,
          width: 250,
          child: (playerController != null
              ? VideoPlayer(
                  playerController,
                )
              : Container()));
    }
    return Container();
  }

  Widget _getOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 234, 206, 0.5),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    print(widget.post);
    print(appState.user.controller.index);
    print("pathiamge");
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          "New Post",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
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
              _addPost(context: context);
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10),
              child: Text(
                "Share",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Column(
                    children: [
                      postType(widget.type, widget.post),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              //  height: 50,
                              //   color: Colors.white,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 20.0, bottom: 10),
                              child: TextFormField(
                                controller: text,
                                maxLines: 4,
                                // onChanged: _onChanged,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(7.0),
                                      ),
                                    ),
                                    fillColor: Colors.white10,
                                    filled: true,
                                    contentPadding:
                                        EdgeInsets.only(top: 10, left: 10),
                                    hintText: "Write caption",
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.black26)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _loading
                      ? _getOverlay()
                      : SizedBox(
                          width: 1,
                        )
                ],
              )),
        ),
      ),
    );
  }
}
