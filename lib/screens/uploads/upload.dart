import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/uploads/video.dart';
import 'package:provider/provider.dart';

import 'camera.dart';
import 'gallery.dart';

class Upload extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UploadState();
  }
}

class UploadState extends State<Upload> {
  // Map<dynamic, dynamic> allImageInfo = new HashMap();
  // List allImage = new List();
  // List allNameList = new List();

  @override
  void initState() {
    super.initState();
    //  loadImageList();
    // main();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return MaterialApp(
      home: DefaultTabController(
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
              )
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.white,
          ),
          body: TabBarView(children: [
            Gallery(),
            CameraScreen(appState.user.cameras),
            VideoScreen(appState.user.cameras)
          ]
              //
              ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
