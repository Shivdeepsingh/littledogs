import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

import 'userProfile.dart';

class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchState();
  }
}

class SearchState extends State<Search> {
  NetworkUtil _networkUtil = NetworkUtil();
  var search = TextEditingController();

  List<Map<String, dynamic>> _newData = [];

  _onChanged(String value) {
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      _newData = appState.user.petList
          .where((row) => row['name'].contains(value))
          .toList();

      // _itemNumber = _newData.length;
      // print(_itemNumber);
      print(_newData.length);
    });
  }

  getSearchCat({BuildContext context}) {
    final appState = Provider.of<AppState>(context, listen: false);
    _newData = appState.user.petList
        .where((row) => row['name'].contains(search.text))
        .toList();
    setState(() {});
    // _itemNumber = _newData.length;
    //print(_itemNumber);
    print(_newData.length);
  }

  List<Widget> _getDetails() {
    List<Widget> detail = [];

    final appState = Provider.of<AppState>(context, listen: false);

    if (_newData.length != 0) {
      for (var list in _newData) {
        if (list['user_id'] != appState.user.userId) {
          detail.add(GestureDetector(
            onTap: () {
              print(list['user_id']);
              print(list);

              if (appState.user.followingList.length != 0) {
                for (var id in appState.user.followingList) {
                  if (id['to_user_id'] == list['user_id']) {
                    appState.user.showData = true;
                  } else {
                    appState.user.showData = false;
                  }
                }
              } else {
                appState.user.showData = false;
              }

              if (appState.user.followRequestSend.length != 0) {
                for (var data in appState.user.followRequestSend) {
                  if (data['to_user_id'] == list['user_id']) {
                    appState.user.requestSend = true;
                    appState.notifyChange();
                  } else {
                    appState.user.requestSend = false;
                    appState.notifyChange();
                  }
                }
              } else {
                appState.user.requestSend = false;
                appState.notifyChange();
              }

              appState.petDetails.addPetId(0);
              appState.petDetails.addDogName("");
              appState.petDetails.addImage("");
              appState.petDetails.addDogBreed("");
              appState.petDetails.addDogColor("");
              appState.petDetails.addGender("");
              appState.petDetails.addDogAge("");
              appState.petDetails.addConcern("");

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(
                          userId: list['user_id'],
                        )),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  list['pet_img'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(list['pet_img']),
                          backgroundColor: Colors.amberAccent,
                          minRadius: 15,
                          maxRadius: 25,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://static.toiimg.com/thumb/msid-60132235,imgsize-169468,width-800,height-600,resizemode-75/60132235.jpg"),
                          backgroundColor: Colors.amberAccent,
                          minRadius: 15,
                          maxRadius: 25,
                        ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: list['name'] != null
                        ? Text(
                            list['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        : Text(""),
                  )
                ],
              ),
            ),
          ));
        }
      }
    }

    return detail;
  }

  _getRequest() async {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.userSendFollowRequest, body: {
      "id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      var extracted = json.decode(value.body);
      print(value.body);

      if (extracted["success"] == true) {
        for (var data in extracted['response']) {
          appState.user.followRequestSend.add(data);
          appState.notifyChange();
        }
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRequest();
    getSearchCat(context: context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  height: 40,
                  //   color: Colors.white,
                  margin: EdgeInsets.only(
                      left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                  child: TextFormField(
                    controller: search,
                    onChanged: _onChanged,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        fillColor: Colors.white24,
                        filled: true,
                        //  suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                        hintText: "Search",
                        hintStyle:
                            TextStyle(fontSize: 15, color: Colors.black26)),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: ListView.builder(
                itemCount: _getDetails().length,
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return _getDetails()[index];
                })));
  }
}
