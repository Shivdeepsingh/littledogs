import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../tabscreen.dart';

class StoryUpload extends StatefulWidget {
  File file;
  String type;
  StoryUpload({this.file, this.type});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StoryUploadState();
  }
}

class StoryUploadState extends State<StoryUpload> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var text = TextEditingController();
  bool _loading = false;
  dynamic data = [];
  TabController controller;

  VideoPlayerController playerController;
  VoidCallback listener;

  void initializeVideo() async {
    try {
      playerController = VideoPlayerController.file(widget.file)
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

  _addStory({BuildContext context}) async {
    setState(() {
      _loading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);

    // open a bytestream
    print(widget.file.path);
    var stream =
        new http.ByteStream(DelegatingStream.typed(widget.file.openRead()));
    // get file length
    var length = await widget.file.length();
    // string to uri
    var uri = Uri.parse(Constants.url + Constants.addStory);
    print(uri);
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile(
        'story_img_or_video', stream, length,
        filename: widget.file.path.split('/').last);

    // add file to multipart
    request.files.add(multipartFile);
    print(multipartFile.filename);
    request.fields.addAll({
      "post_story_type": widget.type,
      "story_name": "story",
      "story_text": "hello",
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
        if (widget.type == "image") {
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
        if (widget.type == "video") {
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
      print("sdsjd");
    });
  }

  Widget postType(String type, File post) {
    if (type == "image") {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.file(
          widget.file,
          fit: BoxFit.cover,
        ),
      );
    }
    if (type == "video") {
      return Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: (playerController != null
              ? VideoPlayer(
                  playerController,
                )
              : Container()));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _addStory(context: context);
        },
        label: _loading
            ? CircularProgressIndicator()
            : Text(
                "Submit",
                style: TextStyle(color: Colors.black),
              ),
        icon: Icon(
          Icons.check,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [postType(widget.type, widget.file)],
      ),
    );
  }
}
