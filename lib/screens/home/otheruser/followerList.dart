import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:provider/provider.dart';

class FollowerList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FollowerListState();
  }
}

class FollowerListState extends State<FollowerList> {
  Widget _followList({AppState appState, int index}) {
    return GestureDetector(
      onTap: () {
        // if (appState.user.followingList.length != 0) {
        //   for (var id in appState.user.followingList) {
        //     if (id['to_user_id'] ==
        //         appState.user.followerList[index]['user_id']) {
        //       appState.user.showData = true;
        //     } else {
        //       appState.user.showData = false;
        //     }
        //   }
        // } else {
        //   appState.user.showData = false;
        // }
        //
        // if (appState.user.followRequestSend.length != 0) {
        //   for (var data in appState.user.followRequestSend) {
        //     if (data['to_user_id'] ==
        //         appState.user.followerList[index]['user_id']) {
        //       appState.user.requestSend = true;
        //       appState.notifyChange();
        //     } else {
        //       appState.user.requestSend = false;
        //       appState.notifyChange();
        //     }
        //   }
        // } else {
        //   appState.user.requestSend = false;
        //   appState.notifyChange();
        // }
        //
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => UserProfile(
        //             userId: appState.user.followerList[index]['user_id'],
        //           )),
        // );

        print(appState.otherUser.followerList[index]['user_id']);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            appState.otherUser.followerListDetail[index]['pet_img'] != null
                ? CircleAvatar(
                    backgroundColor: Colors.amberAccent,
                    minRadius: 10,
                    maxRadius: 20,
                    backgroundImage: NetworkImage(
                        appState.otherUser.followerListDetail[index]['pet_img']),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.amberAccent,
                    minRadius: 10,
                    maxRadius: 20,
                  ),
            SizedBox(
              width: 10,
            ),
            appState.otherUser.followerListDetail[index]['name'] != null
                ? Container(
                    child: Text(
                      appState.otherUser.followerListDetail[index]['name'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        title: Text(
          "Follower List",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: appState.otherUser.followerListDetail.length != 0
          ? Container(
              child: ListView.builder(
                  itemCount: appState.otherUser.followerListDetail.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    return _followList(appState: appState, index: index);
                  }),
            )
          : Container(
              child: Text("No Likes Yet"),
            ),
    );
  }
}
