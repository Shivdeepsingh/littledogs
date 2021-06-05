import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/screens/home/story/camera.dart';
import 'package:littledog/screens/home/story/gallery.dart';
import 'package:littledog/screens/home/story/video.dart';

class StoryTab extends StatefulWidget {
  List<CameraDescription> cameras;
  StoryTab(this.cameras);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StoryTabState();
  }
}

class StoryTabState extends State<StoryTab> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                text: "Gallery",
              ),
              Tab(
                text: "Camera",
              ),
              Tab(
                text: "Video",
              ),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.white,
          ),
          body: TabBarView(children: [
            Gallery(),
            CameraScreen(widget.cameras),
            VideoScreen(widget.cameras)
          ]
              //
              ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
