import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/screens/uploads/uploadimage.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class VideoScreen extends StatefulWidget {
  List<CameraDescription> cameras;

  VideoScreen(this.cameras);

  @override
  VideoScreenState createState() {
    return VideoScreenState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class VideoScreenState extends State<VideoScreen>
    with TickerProviderStateMixin {
  CameraDescription _currentSelectedCamera;
  bool _isLoading = false;
  Timer timer;
  AnimationController animationController;
  String imagePath;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CameraController _controller;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;

  @override
  void initState() {
    try {
      onCameraSelected(widget.cameras.first);

      _currentSelectedCamera = widget.cameras.first;
    } catch (e) {
      print(e.toString());
    }

    animationController =
        AnimationController(duration: Duration(seconds: 15), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No Camera Found!',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
        key: _scaffoldKey,
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            buildContainer(),
            _isLoading
                ? _getOverlay()
                : SizedBox(
                    width: 1,
                  )
          ],
        ));
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

  Widget buildContainer() {
    return Container(
      child: Stack(
        children: <Widget>[
          CameraPreview(_controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 120.0,
              padding: EdgeInsets.all(20.0),
              color: Color.fromRGBO(00, 00, 00, 0.7),
              child: Stack(
                alignment: Alignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Align(
                                      alignment: FractionalOffset.center,
                                      child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned.fill(
                                              child: CustomPaint(
                                                  painter: CustomTimerPainter(
                                                animation: animationController,
                                                backgroundColor: Colors.white,
                                                color: Colors.red,
                                              )),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                animationController.reverse(
                                                    from: animationController
                                                                .value ==
                                                            0.0
                                                        ? 1.0
                                                        : animationController
                                                            .value);

                                                onVideoRecordButtonPressed();
                                              },
                                              child: Align(
                                                alignment:
                                                    FractionalOffset.center,
                                                child: Icon(
                                                  Icons.switch_video,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                  Container(
                      alignment: Alignment.topRight,
                      child: RawMaterialButton(
                        child: Icon(
                          Icons.switch_camera,
                          color: Colors.black,
                        ),
                        shape: new CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                        onPressed: () {
                          _switchCamera();
                        },
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _switchCamera() async {
    // loop through all cameras and find current screens.camera, then move to next
    for (var camera in widget.cameras) {
      if (camera.name == _currentSelectedCamera.name) {
        var x = widget.cameras.indexOf(camera);

        setState(() {
          if (x == widget.cameras.length - 1) {
            _currentSelectedCamera = widget.cameras.first;
          } else {
            _currentSelectedCamera = widget.cameras[x + 1];
          }
        });

        _controller = CameraController(
          _currentSelectedCamera,
          ResolutionPreset.max,
          //   enableAudio: true,
        );

        // If the controller is updated then update the UI.
        _controller.addListener(() {
          if (mounted) setState(() {});
          if (_controller.value.hasError) {}
        });

        try {
          _controller.initialize();
        } on CameraException catch (e) {
          print(e);
        }
        break;
      }
    }
  }

  void onCameraSelected(CameraDescription cameraDescription) async {
    // if (controller != null) await controller.dispose();
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);

    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showSnackBar('Camera Error: ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showException(e);
    }

    if (mounted) setState(() {});
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  // void setCameraResult() {
  //   print(videoPath);
  //   print("jdhjkdfh");
  //   File file = new File(videoPath);
  //   videoUpload(file);
  // }

  // void videoUpload(File video) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => UploadImage(
  //               post: video,
  //               type: "video",
  //               value: "video",
  //             )),
  //   );
  //
  //   print(video);
  //   // final appState = Provider.of<AppStateModel>(context);
  //   // StorageReference storageReference = FirebaseStorage.instance
  //   //     .ref()
  //   //     .child('videos/${Path.basename(video.path)}}');
  //   // StorageUploadTask uploadTask = storageReference.putFile(video);
  //   // await uploadTask.onComplete;
  //   //
  //   // appState.userDetail.isImageLoading = true;
  //   // appState.notifyChange();
  //
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   // storageReference.getDownloadURL().then((fileURL) async {
  //   //   SharedPreferences sharedPreferences =
  //   //       await SharedPreferences.getInstance();
  //   //
  //   //   sharedPreferences.setString("video", fileURL);
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // await db
  //   //     .collection('users')
  //   //     .document(appState.profile.profileId)
  //   //     .updateData({"profilePicVideo": fileURL, "imageType": "video"}).then(
  //   //         (value) {
  //   //   appState.userDetail.addImageType("video");
  //   //   appState.userDetail.isImageLoading = false;
  //   //   appState.notifyChange();
  //   //   Navigator.pushReplacement(
  //   //     context,
  //   //     MaterialPageRoute(
  //   //         builder: (context) => EditProfile(
  //   //               url: fileURL,
  //   //             )),
  //   //   );
  //   // });
  //
  //   // setState(() {
  //   //   print(fileURL);
  //   // });
  //   //  });
  // }

  void onVideoRecordButtonPressed() {
    timer = new Timer(const Duration(seconds: 15), () {
      setState(() {
        onStopButtonPressed();
      });
    });

    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((filePath) {
      if (mounted) setState(() {});
      print(filePath);
      print("video file post");
      if (filePath != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadImage(
                    post: File(filePath.path),
                    value: "video",
                    type: "video",
                  )),
        );
      }
    });
  }

  Future<void> startVideoRecording() async {
    if (!_controller.value.isInitialized) {
      showSnackBar('Error: select a screens.camera first.');
      return null;
    }

    if (_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller.startVideoRecording();
    } on CameraException catch (e) {
      _showException(e);
      return null;
    }
  }

  Future<XFile> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      return _controller.stopVideoRecording();
    } on CameraException catch (e) {
      return null;
    }
  }

  void _showException(CameraException e) {
    logError(e.code, e.description);
    showSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showSnackBar(String message) {}

  void logError(String code, String message) =>
      print('Error: $code\nMessage: $message');
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), 1 / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

class SwitchCamerasButton extends StatelessWidget {
  const SwitchCamerasButton({
    Key key,
    @required this.onSwitchCamerasBtnPressed,
  }) : super(key: key);

  final Function onSwitchCamerasBtnPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        Icons.switch_camera,
        color: Colors.black,
      ),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(15.0),
      onPressed: () {
        onSwitchCamerasBtnPressed();
      },
    );
  }
}
