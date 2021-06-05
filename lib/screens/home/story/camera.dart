import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/screens/home/story/storyupload.dart';
import 'package:path_provider/path_provider.dart' as path;

// ignore: must_be_immutable
class CameraScreen extends StatefulWidget {
  List<CameraDescription> cameras;

  CameraScreen(this.cameras);

  @override
  CameraScreenState createState() {
    return CameraScreenState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  CameraDescription _currentSelectedCamera;
  bool _isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CameraController _controller;

  @override
  void initState() {
    try {
      onCameraSelected(widget.cameras.first);

      _currentSelectedCamera = widget.cameras.first;
    } catch (e) {
      print(e.toString());
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Future<XFile> takePicture() async {
  //
  //   if (_controller == null || !_controller.value.isInitialized) {
  //     print("nbnbn");
  //     //showInSnackBar('Error: select a camera first.');
  //     return null;
  //   }
  //
  //   if (_controller.value.isTakingPicture) {
  //     print("nbnbn{Pending");
  //     // A capture is already pending, do nothing.
  //     return null;
  //   }
  //
  //   try {
  //     XFile file = await _controller.takePicture();
  //     print(file.path);
  //     print("abvvcgg");
  //     return file;
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     return null;
  //   }
  // }


  Future<XFile> takePicture() async {

    if (_controller == null || !_controller.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final image =   await _controller.takePicture();

      print("FileImgae $image");

      return image;
    } on CameraException catch (e,s) {


      print('ErrorException: ${e.code}\n${e.description}');
      print('ErrorException: ${s}');
      //_showCameraException(e,s);
      return null;
    }
  }
  void _showCameraException(CameraException e, CameraException s) {
    logError(e.code, e.description);
    print(e.code);
   print('ErrorException: ${e.code}\n${e.description}');
    print('ErrorException: ${s.code}\n${s.description}');
  }



  void onTakePictureButtonPressed() {
    takePicture().then((XFile file) {
      if (mounted) {
        setState(() {
              if(file != null){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryUpload(
                        file: File(file.path),
                        type: "image",
                      ),
                    ));
              }
        });
        if (file != null) {
          print('Picture saved to ${file.path}');
        }
      }
    });
  }

  // void onTakePictureButtonPressed() {
  //   takePicture().then((XFile filePath) {
  //     if (mounted) {
  //       // setState(() {
  //       //   imagePath = filePath;
  //       // });
  //       print(filePath.path);
  //       print("filepath");
  //     if(filePath != null){
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => StoryUpload(
  //               file: File(filePath.path),
  //               type: "image",
  //             ),
  //           ));
  //     }
  //       print(filePath);
  //       // if (filePath != null) showInSnackBar('Picture saved to $filePath');
  //     }
  //   });
  // }

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
                  Container(
                      // alignment: Alignment.topRight,
                      child: RawMaterialButton(
                    child: Icon(
                      Icons.camera_alt,
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                    onPressed: _controller != null &&
                            _controller.value.isInitialized &&
                            !_controller.value.isRecordingVideo
                        ? onTakePictureButtonPressed
                        : null,
                  )),
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
