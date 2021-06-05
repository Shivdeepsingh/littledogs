import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class MainProfileVideo extends StatefulWidget {
  MainProfileVideo(this.video);
  String video;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainProfileVideoState();
  }
}

class MainProfileVideoState extends State<MainProfileVideo> {
  VideoPlayerController playerController;
  VoidCallback listener;

  void initializeVideo() async {
    try {
      playerController = VideoPlayerController.network(widget.video)
        ..addListener(listener)
        ..setVolume(0.0)
        ..initialize()
        ..setLooping(false)
        ..pause();
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
        height: 50,
        child: Stack(
          children: [
            (playerController != null
                ? VideoPlayer(playerController)
                : Container()),
          ],
        ));
  }
}
