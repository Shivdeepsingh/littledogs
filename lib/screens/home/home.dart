import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:intl/intl.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/chat/chatlist.dart';
import 'package:littledog/screens/home/story/tab.dart';
import 'package:littledog/screens/home/storylist.dart';
import 'package:littledog/screens/home/videopost.dart';
import 'package:littledog/screens/startup/login.dart';
import 'package:littledog/screens/startup/registration/bottomsheet.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipedetector/swipedetector.dart';

import 'comment.dart';
import 'likewidget.dart';
import 'otheruser/serach.dart';
import 'otheruser/userProfile.dart';
import 'zoomOverlay.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  NetworkUtil _networkUtil = NetworkUtil();
  bool _loading = false;
  final FlareControls flareControls = FlareControls();

  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _load = false;

  int offset = 5;

  dynamic list = [];
  dynamic likes = [];
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //  var userLikes = List<int>();

  Future<Null> main() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.user.cameras = await availableCameras();
    } on CameraException catch (e, s) {
      // print(e.toString());
      // print(s.toString());
      //logError(e.code, e.description);
    }
  }

  @override
  void initState() {
    super.initState();
    main();
    _feedList();
    _petDetails();
    _getStoryList();
    _followingList();
    _followerList();
    _getRequest();

    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     ////  _showItemDialog(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     //  _navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     //     _navigateToItemDetail(message);
    //   },
    // );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(
    //         sound: true, badge: true, alert: true, provisional: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    print("scroll");
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

  _scrollListener() {
    print("scrollController");

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("scroll2");
      setState(() {
        offset += 5;
      });

      _getMoreFeed();
    }
  }

  _getMoreFeed() {
    setState(() {
      _load = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.postList, body: {
      "limit": 10,
      "offset": offset
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) async {
      print(value.body);

      var extracted = json.decode(value.body);
      list = extracted['post_detail'];

      if (extracted['message'] == "Invalid Token") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new Login()),
        );
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.clear();
      }

      setState(() {
        _load = false;
      });

      if (extracted['status'] == true) {
        if (list.length == 0) {
          final snackBar = SnackBar(
            content: Text("No More Data"),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }

        if (list != null) {
          for (var data in list) {
            appState.post.feedList.add(data);
            appState.notifyChange();
          }
        }

        for (var user in extracted['pet_detail']) {
          appState.post.postUser.add(user);
          appState.notifyChange();
        }
      }
    }).catchError((error, s) {
      setState(() {
        _load = false;
      });
      print(s.toString());
      print(error.toString());
    });
  }

  _followingList() async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.followingList, body: {
      "id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);
      //   _details = extracted['detail'];
      appState.user.followingList.clear();
      appState.user.followingListDetail.clear();
      if (extracted['status'] == true) {
        for (var data in extracted['detail']) {
          appState.user.followingList.add(data);
          appState.notifyChange();
        }
        for (var petData in extracted['user_data']) {
          appState.user.followingListDetail.add(petData);
          appState.notifyChange();
        }
      }
      print("followingList");
    }).catchError((error, s) {
      print(s.toString());
    });
  }

  Widget _feedData(BuildContext context, int index, AppState appState) {
    //  appState.post.likesLength = appState.post.feedList[index]['likes'].length;

    print(appState.post.feedList[index]['createdAt']);

    DateTime dateTime =
        DateTime.parse(appState.post.feedList[index]['createdAt']);
    var dateFormatted = DateFormat.yMMMd().format(dateTime);

    return Container(
      margin: EdgeInsets.only(top: 0.0),
      child: Column(
        children: [
          Container(
            height: 0.5,
            width: MediaQuery.of(context).size.width,
            color: Colors.black26,
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                userData(index: index, appState: appState),
              ],
            ),
          ),
          Container(
            height: 0.5,
            width: MediaQuery.of(context).size.width,
            color: Colors.black26,
          ),
          GestureDetector(
            onDoubleTap: () {
              flareControls.play("like");
            },
            child: Stack(
              children: [
                feedType(
                    type: appState.post.feedList[index]['post_type'],
                    post: appState.post.feedList[index]['post']),
                Container(
                  width: double.infinity,
                  height: 250,
                  child: Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: FlareActor(
                        'assets/like.flr',
                        controller: flareControls,
                        animation: 'idle',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: LikeWidget(
              image: appState.post.feedList[index]['post'],
              postId: appState.post.feedList[index]['post_id'],
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               LikeList(appState.post.feedList[index]['post_id'])),
          //     );
          //   },
          //   child:
          //       LikesLength(appState.post.feedList[index]['post_id'], context),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Dog Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),flex: 3,),
             Flexible(child:  Container(
               alignment: Alignment.topLeft,
               margin: EdgeInsets.only(left: 0.0, top: 10),
               child: Text(
                 appState.post.feedList[index]['post_name'],
                 style: TextStyle(),
               ),
             ),flex: 7,)
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Comments(
                        postId: appState.post.feedList[index]['post_id'])),
              );
            },
            child: Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "View all " +
                    // appState.post.feedList[index]['comments'].length
                    //     .toString() +
                    "\tcomments",
                style: TextStyle(color: Colors.black26),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                CircleAvatar(
                  // backgroundImage:
                  //     NetworkImage(appState.post.feedList[index]['pet_img']),
                  backgroundColor: Colors.amberAccent,
                  minRadius: 10,
                  maxRadius: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Comments(
                              postId: appState.post.feedList[index]
                                  ['post_id'])),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Add a comment...",
                      style: TextStyle(color: Colors.black26),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Text(
              dateFormatted,
              style: TextStyle(color: Colors.black26, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget userData({int index, AppState appState}) {
    return GestureDetector(
      onTap: () {
        print(appState.post.postUser[index]);

        if (appState.post.postUser[index]['user_id'] == appState.user.userId) {
          print("user_id");
        } else {
          if (appState.user.followingList.length != 0) {
            for (var id in appState.user.followingList) {
              if (id['to_user_id'] ==
                  appState.post.postUser[index]['user_id']) {
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
              if (data['to_user_id'] ==
                  appState.post.postUser[index]['user_id']) {
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

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfile(
                      userId: appState.post.postUser[index]['user_id'],
                    )),
          );
        }
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: appState.post.postUser[index]['pet_img'] != null
                ? NetworkImage(appState.post.postUser[index]['pet_img'])
                : AssetImage("assets/noimage.png"),
            backgroundColor: Colors.amberAccent,
            minRadius: 10,
            maxRadius: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: appState.post.postUser[index]['name'] != null
                ? Text(appState.post.postUser[index]['name'],
                    style: TextStyle(fontWeight: FontWeight.bold))
                : Text(
                    "",
                    // appState.post.feedList[index]['pet_name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          )
        ],
      ),
    );
  }

  Widget feedType({String type, String post}) {
    if (type == "image") {
      return ZoomOverlay(
          twoTouchOnly: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: post != null
                  ? Image.network(
                      post,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
          ));
    }
    if (type == "Image") {
      return ZoomOverlay(
          twoTouchOnly: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: post != null
                  ? Image.network(
                post,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )
                  : Container(),
            ),
          ));
    }
    if (type == "video") {
      return VideoPost(
        video: post,
      );
    }

    return Container(
      height: 300,
    );
  }

  _feedList() {
    setState(() {
      _loading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.postList, body: {
      "limit": 10,
      "offset": 0
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) async {
      print(value.body);

      var extracted = json.decode(value.body);
      list = extracted['post_detail'];

      if (extracted['message'] == "Invalid Token") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new Login()),
        );
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.clear();
      }
      if (extracted['status'] == true) {
        setState(() {
          _loading = false;
        });
        appState.post.feedList.clear();
        appState.post.postUser.clear();
        if (list != null) {
          for (var data in list) {
            appState.post.feedList.add(data);
            appState.notifyChange();
          }
        }

        for (var user in extracted['pet_detail']) {
          appState.post.postUser.add(user);
          appState.notifyChange();
        }

        //   _itemNumber = appState.post.feedList.length;
      }
      setState(() {
        _loading = false;
      });
    }).catchError((error, s) {
      setState(() {
        _loading = false;
      });
      print(s.toString());
      print(error.toString());
    });
  }

  _bottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 550,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(
                  top: 5, left: 10, right: 10, bottom: 10),
              child: SingleChildScrollView(child: BottomSheetRegister()));
        });
  }

  _followerList() async {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.user.userId);

    _networkUtil.post(Constants.url + Constants.followerList, body: {
      "id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);
      dynamic _details = extracted['detail'];
      appState.user.followerList.clear();
      appState.user.followerListDetail.clear();
      if (extracted['success'] == true) {
        for (var data in _details) {
          appState.user.followerList.add(data);
          appState.chat.checked.add(false);
          appState.notifyChange();
        }
        for (var petData in extracted['pet_detail']) {
          appState.user.followerListDetail.add(petData);
          appState.notifyChange();
        }
      }
      print("followList");
    }).catchError((error, s) {
      print(s.toString());
    });
  }

  _petDetails() async {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.petDetails, body: {
      "user_id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      var extracted = json.decode(value.body);

      if (extracted['message'] == "pet detail not found") {
        _bottomSheet();
      }

      dynamic _details = extracted['pet_detail'];

      if (extracted['message'] == "Pet_detail") {
        appState.petDetails.addPetId(_details["pet_id"]);
        appState.petDetails.addDogName(_details["name"]);
        appState.petDetails.addImage(_details["pet_img"]);
        appState.petDetails.addDogBreed(_details['breed']);
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  List<Widget> _stories({int index}) {
    final appState = Provider.of<AppState>(context, listen: false);

    List<Widget> data = [];
    data.add(GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
            return new StoryTab(appState.user.cameras);
          }));
        },
        child: Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black), shape: BoxShape.circle),
          child: CircleAvatar(
            child: Icon(Icons.add),
            backgroundColor: Colors.white,
            maxRadius: 35,
            minRadius: 25,
          ),
        )));
    if (appState.post.newStoryList.length != 0) {
      for (var i = 0; i < appState.post.newStoryList.length; i++) {
        data.add(GestureDetector(
          onTap: () {
            print(appState.post.newStoryList[i]['user_id']);
            print("storyId");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      StoryList(appState.post.newStoryList[i]['user_id'])),
            );
          },
          child: Container(
            margin: EdgeInsets.all(6),
            child: CircleAvatar(
              backgroundImage: appState.post.newStoryList[i]['pet_img'] != null
                  ? NetworkImage(appState.post.newStoryList[i]['pet_img'])
                  : AssetImage("assets/noimage.png"),
              backgroundColor: Colors.lime,
              maxRadius: 40,
              minRadius: 25,
            ),
          ),
        ));
      }
    }
    return data;
  }

  final newList = [];
  _getStoryList() {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.get(Constants.url + Constants.storyList, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      appState.post.storyList.clear();
      appState.post.storyDetail.clear();
      appState.post.newStoryList.clear();
      appState.post.newStoryDetail.clear();

      if (extracted['status'] == true) {
        for (var data in extracted['pet_info']) {
          appState.post.storyList.add(data);
          appState.notifyChange();
        }

        for (var detail in extracted['story_post']) {
          appState.post.storyDetail.add(detail);
          appState.notifyChange();
        }
      }

      final jsonList1 =
          appState.post.storyDetail.map((item) => jsonEncode(item)).toList();
      final uniqueJsonList1 = jsonList1.toSet().toList();
      final result1 = uniqueJsonList1.map((item) => jsonDecode(item)).toList();
      print(result1.length);
      print(appState.post.storyList.length);

      if (result1.length != 0) {
        for (var data in result1) {
          appState.post.newStoryDetail.add(data);
          appState.notifyChange();
        }
      }

      final jsonList =
          appState.post.storyList.map((item) => jsonEncode(item)).toList();
      final uniqueJsonList = jsonList.toSet().toList();
      final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
      print(result.length);
      print(appState.post.storyList.length);

      if (result.length != 0) {
        for (var data in result) {
          appState.post.newStoryList.add(data);
          appState.notifyChange();
        }
      }

      print("storyListData");

      print("Story List");
    }).catchError((error) {
      print(error);
    });
  }

  _getUserList() {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.get(Constants.url + Constants.userList, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      dynamic list = extracted['response'];

      if (extracted['success'] == true) {
        appState.user.petList.clear();
        for (var data in list) {
          appState.user.petList.add(data);
          appState.notifyChange();
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Search()),
      );
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              _getUserList();
            },
          ),
          IconButton(
            icon: Image.asset("assets/chat.png"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatList()),
              );
            },
          ),
        ],
        leading: Container(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            "assets/logo.jpg",
            width: 15,
            height: 15,
          ),
        ),
        elevation: 5.0,
        title: Text(
          "Little Dog Life",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SwipeDetector(
        onSwipeLeft: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatList()),
          );
          print("swipe right screen");
        },
        child: SafeArea(
            child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: 100,
                child: _stories().length != 0
                    ? ListView.builder(
                        itemCount: _stories().length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return _stories(index: index)[index];
                        })
                    : Container(),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.black12,
              ),
              //  PostScreen()
              _loading
                  ? CircularProgressIndicator()
                  : appState.post.feedList.length == 0
                      ? Center(
                          child: Text("No Feed"),
                        )
                      : Container(
                          // height: MediaQuery.of(context).size.height / 1.5,
                          child: ListView.builder(
                              itemCount: appState.post.feedList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                if (index != 0 && index % 6 == 0) {
                                  return Container(
                                    child: Text(
                                      "Show Ads",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }
                                return _feedData(context, index, appState);
                              }),
                        ),
              _load ? CircularProgressIndicator() : Container()
            ],
          ),
        )),
      ),
    );
  }
}
