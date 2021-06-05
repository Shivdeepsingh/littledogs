import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/tabscreen.dart';
import 'package:littledog/utils/constants.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CameraScreen extends StatefulWidget {
  List<CameraDescription> cameras;

  String screen;

  CameraScreen(this.cameras, this.screen);

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

  String imagePath;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CameraController _controller;
  String videoPath;

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

  Future<Null> _cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    final appState = Provider.of<AppState>(context, listen: false);
    if (croppedFile != null) {
      // if (widget.screen == "register") {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => Info(
      //               image: croppedFile,
      //             )),
      //   );
      //   appState.register.addScreen("upload");
      //   appState.notifyChange();
      // }
      if (widget.screen == "edit") {
        appState.petDetails.addImage(null);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => new EditProfile(image)),
        // );
        _addImage(context: context, image: croppedFile);
      }
      setState(() {
        print(croppedFile);
      });
    }
  }

  _addImage({BuildContext context, File image}) async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);
    print(appState.user.token);
    print("dataUPLOAD");
    // open a bytestream
    print(image.path);
    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    // get file length
    var length = await image.length();
    // string to uri
    var uri = Uri.parse(Constants.url + Constants.profileImage);
    print(uri);
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('pet_img', stream, length,
        filename: image.path.split('/').last);

    // add file to multipart
    request.files.add(multipartFile);
    print(multipartFile.filename);
    request.fields.addAll({
      "pet_id": appState.petDetails.petId.toString(),
    });

    request.headers.addAll({
      "Authorization": "Bearar " + appState.user.token,
    });
    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      Map<String, dynamic> user = jsonDecode(value);
      print("data" + user['message']);
      print("sdsjd");
      if (user['success'] == true) {
        appState.user.activeTab = 4;
        appState.user.controller.animateTo(4);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new TabScreen()),
        );
      }

      print("sdsjd");
    }).onError((error) {
      print(error);
      print("sdsjd");
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<String> takePicture() async {
    if (!_controller.value.isInitialized) {
      //  showInSnackBar('Error: select a screens.camera first.');
      return null;
    }
    final Directory extDir = await path.getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await _controller.takePicture();
    } on CameraException catch (e) {
      print(e);
      // _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        // setState(() {
        //   imagePath = filePath;
        // });
        _cropImage(File(filePath));
        print(filePath);
        // if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
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
              color: Colors.white,
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
                    shape:
                        new CircleBorder(side: BorderSide(color: Colors.black)),
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
                        shape: new CircleBorder(
                            side: BorderSide(color: Colors.black)),
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

  void setCameraResult() {
    File file = new File(videoPath);
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
