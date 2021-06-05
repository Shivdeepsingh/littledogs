import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

class StoryList extends StatefulWidget {
  int userId;

  StoryList(this.userId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StoryListState();
  }
}

class StoryListState extends State<StoryList> {
  final storyController = StoryController();

  NetworkUtil _networkUtil = NetworkUtil();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getStoryDetail();
  }

  List<StoryItem> _story = [];

  _getStoryDetail() {
    print(widget.userId);
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.storyDetail, body: {
      "user_id": widget.userId
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);
      print("story Details");

      if (extracted['success'] == true) {
        if (extracted['response'].length != 0) {
          for (var data in extracted['response']) {
            if (data['post_story_type'] == "story") {
              _story.add(StoryItem.pageImage(
                url: data["story_img_or_video"],
                caption: "",
                duration: Duration(seconds: 15),
                controller: storyController,
              ));
            }
            if (data['post_story_type'] == "image") {
              _story.add(StoryItem.pageImage(
                url: data["story_img_or_video"],
                caption: "",
                duration: Duration(seconds: 15),
                controller: storyController,
              ));
            }
            if (data['post_story_type'] == "video") {
              _story.add(StoryItem.pageVideo(
                data["story_img_or_video"],
                caption: "",
                duration: Duration(seconds: 15),
                controller: storyController,
              ));
            }
          }
        }
        setState(() {});
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      child: StoryView(
        storyItems: _story.length != 0
            ? _story
            : [
                StoryItem.text(
                    title: "hello",
                    duration: Duration(seconds: 15),
                    backgroundColor: Colors.white)
              ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          Navigator.of(context).pop();
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    ));
  }
}
