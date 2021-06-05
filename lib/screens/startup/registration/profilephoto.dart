import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

import '../../tabscreen.dart';

class ProfilePhoto extends StatefulWidget {
  // File image;
  // ProfilePhoto(this.image);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfilePhotoState();
  }
}

class ProfilePhotoState extends State<ProfilePhoto> {
  bool _loading = false;

  NetworkUtil _networkUtil = NetworkUtil();

  File _image;
  final picker = ImagePicker();

  Future getCameraImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        // image = File(pickedFile.path);
        _cropImage(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  Future getGalleryImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        //  image = File(pickedFile.path);
        _cropImage(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  _bottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(
                  top: 5, left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            getCameraImage();
                          }),
                      Text("Camera")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            getGalleryImage();
                          }),
                      Text("Gallery")
                    ],
                  )
                ],
              ));
        });
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
    setState(() {
      print(croppedFile);
      _image = croppedFile;
      Navigator.of(context).pop();
    });
  }

  _addPet({BuildContext context, AppState appState}) async {
    setState(() {
      _loading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);

    // open a bytestream
    print(_image.path);
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    // get file length
    var length = await _image.length();
    // string to uri
    var uri = Uri.parse(Constants.url + Constants.addPet);
    print(uri);
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('pet_img', stream, length,
        filename: _image.path.split('/').last);

    // add file to multipart
    request.files.add(multipartFile);
    print(multipartFile.filename);
    request.fields.addAll({
      "name": appState.register.dogName,
      "breed": appState.register.dogBreed,
      "color": appState.register.dogColor,
      "gender": appState.register.dogGender,
      "dob": appState.register.dogAge,
      "health_concerns": appState.register.dogConcern,
      "user_id": appState.user.userId.toString()
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new TabScreen()),
        );
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

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.register.dogName);
    print(appState.register.dogAge);
    print(appState.register.dogBreed);
    print(appState.register.dogColor);
    print(appState.register.dogConcern);
    print(appState.register.dogGender);
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addPet(appState: appState, context: context);
        },
        child: _loading
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            : Icon(Icons.arrow_forward),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.pinkAccent, width: 2)),
                  child: Container(
                    width: 150,
                    height: 150,
                    // backgroundImage:
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _image != null
                              ? FileImage(_image)
                              : NetworkImage(
                                  "https://p.kindpng.com/picc/s/49-496597_dog-png-fluffy-teacup-pomeranian-white-background-transparent.png"),
                        ),
                        border: Border.all(color: Colors.pink)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _bottomSheet();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ProfileTab("register")),
                    // );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    color: Color(0xFF1d4695),
                    child: Text(
                      "Choose Photo",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
