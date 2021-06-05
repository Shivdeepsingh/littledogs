import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/chat/chatlist.dart';
import 'package:littledog/screens/chat/member/addMemberlist.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class MemberList extends StatefulWidget{

  List<Map<String,dynamic>> list =[];
  final int channelId;

  MemberList({this.list,this.channelId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return MemberListState();
  }
}



class MemberListState extends State<MemberList>{
  dynamic _list =[];
  NetworkUtil _networkUtil = NetworkUtil();
  bool _loadList = false;

  bool _leave = false;

 _memberList (){


   final appState = Provider.of<AppState>(context,listen: false);
        try {
          setState(() {
            _loadList = true;
          });
          print("abcd");
          for(var data in appState.chat.memberList){
            _networkUtil.post(Constants.url + Constants.petDetails, body: {
              "user_id": data['created_by']
            }, headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              "Authorization": "Bearar " + appState.user.token
            }).then((value) {
              print(value.body);
              var extracted = json.decode(value.body);
              _list = extracted['pet_detail'];

              print("Pet Details Group");
              


              appState.chat.memberDetail.add({
                "name" : _list['name'],
                "pet_img" : _list['pet_img']
              });

              appState.notifyChange();
              setState(() {
                _loadList = false;
              });

            }).catchError((error, s) {

              setState(() {
                _loadList = false;
              });
              print(s.toString());
            });
          }

        } catch (e) {
          print(e.toString());
        }
  }

  Widget _member (AppState appState, int index){
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(0),
      child: Row(

        children: [
          CircleAvatar(
            maxRadius: 30,
            minRadius: 20,
            backgroundImage: NetworkImage(appState.chat.memberDetail[index]['pet_img']),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(appState.chat.memberDetail[index]['name'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          ),

        ],
      ),
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _memberList();
  }

  leaveGroup({int channelId,BuildContext context}) {
    setState(() {
      _leave = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.memberLeft, body: {
      "channel_id": channelId,
      "authID": appState.user.userId
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      print("chat List");
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {

        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) =>
            ChatList()));
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _leave = false;
        });
      }
    }).catchError((error) {
      Navigator.of(context).pop();
      setState(() {
        _leave = false;
      });
      print(error.toString());
    });
  }

    showAlertDialog(int channelId) {

      // set up the button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {

         leaveGroup(channelId: channelId,context: context);

        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Leave Group"),
        content: Text("Are you want to leave group?"),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context,listen: false);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: Text("Detail",style: TextStyle(color: Colors.black),),

        actions: [
          GestureDetector(
              onTap: () {
                showAlertDialog(widget.channelId);
              },
              child: _leave ? CircularProgressIndicator() :Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 10, right: 10),
                child: Text(
                  "Leave",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ))
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: (){
          print("Add Members");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddMemberList(channelId: widget.channelId,
                    )),
          );

        },
        child: Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 10,left: 10,right: 10),
          color: Colors.pink,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add,size: 25,color: Colors.white,),
              Text("Add Member",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),

            ],),
        ),
      ),
      body: _loadList ? Center(
        child: CircularProgressIndicator(),
      ) :Container(
        child: appState.chat.memberDetail.length !=0 ? ListView.builder(
            itemCount: appState.chat.memberDetail.length,
            itemBuilder: (BuildContext context, int index){
              return _member(appState, index);
            }): Center(
          child: Text("No Members"),
        ),
      )
    );
  }

}