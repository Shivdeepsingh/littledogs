import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class BottomSheetRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BottomSheetState();
  }
}

class BottomSheetState extends State<BottomSheetRegister> {
  File _image;
  final picker = ImagePicker();
  bool _loading = false;
  NetworkUtil _networkUtil = NetworkUtil();

  dynamic _details = [];

  var name = TextEditingController();
  var breed = TextEditingController();
  var age = TextEditingController();
  var color = TextEditingController();
  var concern = TextEditingController();
  var gender = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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
      "name": name.text,
      "breed": breed.text,
      "color": color.text,
      "gender": gender.text,
      "dob": age.text,
      "health_concerns": concern.text,
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
        Navigator.of(context).pop();
        _petDetails();
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

  _petDetails() async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.petDetails, body: {
      "user_id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      _details = extracted['response'];

      if (extracted['success'] == true) {
        print("petDetails");

        if (extracted['success'] == true) {
          appState.petDetails.addPetId(_details["pet_id"]);
          appState.petDetails.addDogName(_details["name"]);
          appState.petDetails.addImage(_details["pet_img"]);
          appState.petDetails.addDogBreed(_details["breed"]);
          appState.petDetails.addDogColor(_details["color"]);
          appState.petDetails.addGender(_details["gender"]);
          appState.petDetails.addDogAge(_details['dob']);
          appState.petDetails.addConcern(_details['health_concerns']);
          appState.notifyChange();
        }
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "Fill Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.pinkAccent, width: 2)),
              child: Container(
                width: 100,
                height: 100,
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
          ),
          Row(
            children: <Widget>[
              new Flexible(
                child: Padding(
                    padding: EdgeInsets.only(right: 10, top: 20, left: 20),
                    child: new TextFormField(
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins-Regular",
                        ),
                        controller: name,
                        validator: (val) =>
                            val.isEmpty ? 'DogName can\'t be empty.' : null,
                        autocorrect: false,
                        key: new Key('DogName'),
                        decoration: InputDecoration(
                            hintText: 'Dog Name',
                            labelText: "Dog Name",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))))),
              ),
              new Flexible(
                child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 20),
                    child: new TextFormField(
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins-Regular",
                        ),
                        controller: breed,
                        validator: (val) =>
                            val.isEmpty ? 'DogBreed can\'t be empty.' : null,
                        autocorrect: false,
                        key: new Key('DogBreed'),
                        decoration: InputDecoration(
                            hintText: 'Dog Breed',
                            labelText: "Dog Breed",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))))),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              new Flexible(
                child: Padding(
                    padding: EdgeInsets.only(right: 10, top: 20, left: 20),
                    child: new TextFormField(
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins-Regular",
                        ),
                        controller: color,
                        validator: (val) =>
                            val.isEmpty ? 'Dog Color can\'t be empty.' : null,
                        autocorrect: false,
                        key: new Key('Dog Color'),
                        decoration: InputDecoration(
                            hintText: 'Dog Color',
                            labelText: "Dog Color",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))))),
              ),
              new Flexible(
                child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 20),
                    child: new TextFormField(
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins-Regular",
                        ),
                        controller: age,
                        validator: (val) =>
                            val.isEmpty ? 'Dog Age can\'t be empty.' : null,
                        autocorrect: false,
                        key: new Key('Dog Age'),
                        decoration: InputDecoration(
                            hintText: 'Dog Age',
                            labelText: "Dog Age",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))))),
              )
            ],
          ),
          Row(
            children: <Widget>[
              new Flexible(
                child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 20, left: 20),
                    child: new TextFormField(
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins-Regular",
                        ),
                        controller: gender,
                        validator: (val) =>
                            val.isEmpty ? 'Gender can\'t be empty.' : null,
                        autocorrect: false,
                        key: new Key('gender'),
                        decoration: InputDecoration(
                            hintText: 'Gender',
                            labelText: "Gender",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))))),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              new Flexible(
                child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 20, left: 20),
                    child: new TextFormField(
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins-Regular",
                        ),
                        controller: concern,
                        validator: (val) =>
                            val.isEmpty ? 'concern can\'t be empty.' : null,
                        autocorrect: false,
                        key: new Key('concern'),
                        decoration: InputDecoration(
                            hintText: 'Health Concern',
                            labelText: "Health Concern",
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))))),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pop();
              _addPet(context: context);
            },
            child: _loading
                ? CircularProgressIndicator()
                : Container(
                    width: 150,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 20, top: 30),
                    alignment: Alignment.center,
                    color: Color(0xFF0e70be),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
