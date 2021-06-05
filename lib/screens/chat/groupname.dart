import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/chat/chatlist.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class GroupName extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GroupNameState();
  }
}

class GroupNameState extends State<GroupName> {
  NetworkUtil _networkUtil = NetworkUtil();
  final formKey = new GlobalKey<FormState>();

  var text = TextEditingController();

  File image;
  final picker = ImagePicker();

  bool _loading = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future getGalleryImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _addGroup({BuildContext context, AppState appState}) async {

    setState(() {
      _loading = true;
    });

    print(image);
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    // get file length
    var length = await image.length();
    // string to uri
    var uri = Uri.parse(Constants.url + Constants.createGroup);
    print(uri);
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('icon', stream, length,
        filename: image.path.split('/').last);

    // add file to multipart
    request.files.add(multipartFile);
    print(multipartFile.filename);
    request.fields.addAll({
      "authID": appState.user.userId.toString(),
      "name": text.text,
    });
    print(request.fields);

    request.headers.addAll({
      "Authorization": "Bearar " + appState.user.token,
    });
    // send
    var response = await request.send();

    print(response.stream);
    print(response.request);

    print(response.statusCode);
    print("jdjfhkjsdfh");

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      Map<String, dynamic> user = jsonDecode(value);
      print(user);
      print("sdsjd");

      var response = user['response'];

      if (user['success'] == true) {
        for (var data in appState.chat.groupList) {
          _addMember(response['group_id'], data['userId'], appState);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatList()),
        );
        setState(() {
          _loading = false;
        });
      }
    }).onError((error) {
      setState(() {
        _loading = false;
      });
      print(error);
      print("sdsjd");
    });
  }

  _addMember(int channelId, int authId, AppState appState) {
    _networkUtil.post(Constants.url + Constants.addMember, body: {
      "channel_id": channelId,
      "authID": authId
    }, headers: {
      "Authorization": "Bearar " + appState.user.token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    }).then((value) {
      print(value.body);
      print('group Data');
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              GestureDetector(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black),
                      image: DecorationImage(
                          image: image != null
                              ? FileImage(image)
                              : AssetImage("assets/noimage.png"))),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      //   height: _height,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: TextFormField(
                        onTap: () {},
                        controller: text,
                        validator: (val) =>
                            val.isEmpty ? 'Group Name can\'t be empty.' : null,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(7.0),
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(top: 10, left: 10),
                            hintText: "Group Name",
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black26)),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                if(image != null){
                  _addGroup(appState: appState, context: context);
                }else{
                  Fluttertoast.showToast(
                      msg: "Please Choose Image First",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                },
                child: _loading? CircularProgressIndicator(): Container(
                  width: 150,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 20, top: 20),
                  alignment: Alignment.center,
                  color: Color(0xFF0e70be),
                  child: Text(
                    "Create Group",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
