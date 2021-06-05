import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/tabscreen.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
 final  File image;
  EditProfile(this.image);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfile> {
  var name = TextEditingController();
  var breed = TextEditingController();
  var age = TextEditingController();
  var color = TextEditingController();
  var gender = TextEditingController();

  bool _loading = false;
  NetworkUtil _networkUtil = NetworkUtil();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

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
      _addImage(context: context, image: croppedFile);
    });
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

  _updatePet() async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.updatePet, body: {
      "name": name.text,
      "breed": breed.text,
      "color": color.text,
      "gender": gender.text,
      "dob": age.text,
      "health_concerns": appState.petDetails.dogConcern,
      "pet_id": appState.petDetails.petId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        appState.user.activeTab = 4;
        appState.user.controller.animateTo(4);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new TabScreen()),
        );
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    name.text = appState.petDetails.dogName;
    age.text = appState.petDetails.dogAge;
    color.text = appState.petDetails.dogColor;
    breed.text = appState.petDetails.dogBreed;
    gender.text = appState.petDetails.dogGender;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _updatePet();
              //   Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.check,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ],
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundImage: appState.petDetails.image != null
                      ? NetworkImage(appState.petDetails.image)
                      : FileImage(widget.image),
                  backgroundColor: Colors.amberAccent,
                  maxRadius: 55,
                  minRadius: 45,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _bottomSheet();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ProfileTab("edit")),
                  // );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "Change Profile Picture",
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Text(
                  "Dog Name",
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 0.0, bottom: 10),
                      child: TextFormField(
                        controller: name,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          // border: new OutlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Colors.white, width: 0.0),
                          //   borderRadius: const BorderRadius.all(
                          //     const Radius.circular(7.0),
                          //   ),
                          // ),
                          fillColor: Colors.white10,
                          filled: true,
                          // suffixIcon: _showPassword
                          //     ? Icon(Icons.remove)
                          //     : Icon(Icons.remove_red_eye),
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Text(
                  "Dog Breed",
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 0.0, bottom: 10),
                      child: TextFormField(
                        controller: breed,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          // border: new OutlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Colors.white, width: 0.0),
                          //   borderRadius: const BorderRadius.all(
                          //     const Radius.circular(7.0),
                          //   ),
                          // ),
                          fillColor: Colors.white10,
                          filled: true,
                          // suffixIcon: _showPassword
                          //     ? Icon(Icons.remove)
                          //     : Icon(Icons.remove_red_eye),
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Text(
                  "Dog Age",
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 0.0, bottom: 10),
                      child: TextFormField(
                        controller: age,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          // border: new OutlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Colors.white, width: 0.0),
                          //   borderRadius: const BorderRadius.all(
                          //     const Radius.circular(7.0),
                          //   ),
                          // ),
                          fillColor: Colors.white10,
                          filled: true,
                          // suffixIcon: _showPassword
                          //     ? Icon(Icons.remove)
                          //     : Icon(Icons.remove_red_eye),
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Text(
                  "Dog color",
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 0.0, bottom: 10),
                      child: TextFormField(
                        controller: color,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          // border: new OutlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Colors.white, width: 0.0),
                          //   borderRadius: const BorderRadius.all(
                          //     const Radius.circular(7.0),
                          //   ),
                          // ),
                          fillColor: Colors.white10,
                          filled: true,
                          // suffixIcon: _showPassword
                          //     ? Icon(Icons.remove)
                          //     : Icon(Icons.remove_red_eye),
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Text(
                  "Dog Gender",
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 0.0, bottom: 10),
                      child: TextFormField(
                        controller: gender,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          // border: new OutlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Colors.white, width: 0.0),
                          //   borderRadius: const BorderRadius.all(
                          //     const Radius.circular(7.0),
                          //   ),
                          // ),
                          fillColor: Colors.white10,
                          filled: true,
                          // suffixIcon: _showPassword
                          //     ? Icon(Icons.remove)
                          //     : Icon(Icons.remove_red_eye),
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
