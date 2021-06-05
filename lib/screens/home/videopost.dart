import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  String video;

  VideoPost({this.video});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VideoPostState();
  }
}

class VideoPostState extends State<VideoPost> {
  VideoPlayerController playerController;
  VoidCallback listener;
  bool isMute = false;

  void initializeVideo() async {
    try {
      playerController = VideoPlayerController.network(widget.video)
        ..addListener(listener)
        ..initialize()
        ..setVolume(0.0)
        ..setLooping(true)
        ..play();
    } catch (e, s) {
      print(e.toString());
      print(s.toString());
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      height: 400,
      child:

      Stack(
        children: [

          (playerController != null
              ? VideoPlayer(playerController)
              : Container()),

          Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(bottom: 20),
              child: IconButton(
                  icon: !isMute
                      ? Icon(Icons.play_circle_fill,color: Colors.white,size: 25,)
                      :Icon(Icons.pause,color: Colors.white,size: 25,),
                  onPressed: () {
                    playerController.setVolume(!isMute ? 1 : 0);
                    setState(
                          () {
                        isMute = !isMute;
                      },
                    );
                  })),
        ],
      )


    );
  }
}
