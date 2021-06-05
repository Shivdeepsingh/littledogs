import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final int senderId;
  final int recieverId;
  final String image;
  final String name;
  int channelId;

  ChatScreen(
      {this.senderId, this.recieverId, this.image, this.name, this.channelId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  List<String> messages;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  NetworkUtil _networkUtil = NetworkUtil();
  List<Map<String, dynamic>> _chatMessage = [];
  bool isShowSticker;
  bool _isImage = false;

  ScrollController _scrollController = new ScrollController();

  // IO.Socket _socket;
  SocketIO socketIO;

  final picker = ImagePicker();

  File _image;

  bool _enterText = false;

  StreamController _chatController;

  Future getGalleryImage(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        print(_image);
        _addSendImageWithMessage(image: _image, context: context);
      } else {
        print('No image selected.');
      }
    });
  }

  fetchPost() async {
    final appState = Provider.of<AppState>(context, listen: false);

    final response = await http.post(
        Uri.parse('http://139.59.27.120:7000/v2/private-message-display'),
        body: {"channel_id": widget.channelId.toString()},
        headers: {"Authorization": "Bearar " + appState.user.token});

    //print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  loadPosts() async {
    fetchPost().then((res) async {
      print(res);
      _chatMessage.clear();
      print("sghsgdhdg");
      if (res['success'] == true) {
        for (var data in res['detail']) {
          _chatMessage.add(data);
          setState(() {});
          print("messageDetails");
          print(data['user_info']);
        }
      }
      Timer(
          Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
      // _chatController.add(res);
      return res;
    });
  }

  _connect() {
    print("connection");

    socketIO = SocketIOManager().createSocketIO(Constants.url, "/",
        socketStatusCallback: _socketStatus);

    //call init socket before doing anything
    socketIO.init();

    //connect socket
    socketIO.connect();
  }

  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  @override
  void initState() {
    //Initializing the message list
    super.initState();
    _connect();
    textController = TextEditingController();
    textController.addListener(() {
      if (textController.text.isNotEmpty) {
        setState(() {
          _enterText = true;
        });
      } else {
        setState(() {
          _enterText = false;
        });
      }
    });

    messages = List<String>();

    _chatController = new StreamController();
    loadPosts();
    // _connect();

    try {
      // subscribe event
      socketIO.subscribe("message", (data) {
        var mm = json.decode(data);
        print(mm);
        print("Socket Chat");
        print(widget.channelId);
        print(mm['group_id']);
        if (widget.channelId == mm['group_id']) {
          print("abc");
          _chatMessage.add({
            "msg": mm['msg'],
            "created_by": mm['created_by'],
            "doc": mm['doc'],
            "type": mm['type']
          });
        }
        print("ChatMessageData $_chatMessage");
        Timer(
            Duration(milliseconds: 500),
            () => _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent));

        setState(() {});
      });
      socketIO.subscribe("123", (data) => print(data));
    } catch (e) {
      print(e.toString());
    }
    scrollController = ScrollController();
    // Creating the socket
    isShowSticker = false;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    final appState = Provider.of<AppState>(context, listen: false);

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.amberAccent,
                backgroundImage: NetworkImage(widget.image),
                maxRadius: 20,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                widget.name,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
        body: Stack(
          //  controller: _scrollController,
          children: [
            Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _chatMessage.length,
                    itemBuilder: (BuildContext context, int index) {
                      var post = _chatMessage[index];

                      print(post);
                      print(post['message_id']);

                      print("data Chat");

                      if (post['created_by'] == appState.user.userId) {
                        if (post['type'] == "image") {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _bottomSheet(post['message_id']);
                                },
                                child: _isImage
                                    ? CircularProgressIndicator()
                                    : Container(
                                        height: 200,
                                        width: 200,
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurpleAccent,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: CachedNetworkImage(
                                          imageUrl: post['doc'],
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )),
                              )
                            ],
                          );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _bottomSheet(post['message_id']);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurpleAccent,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: post['msg'] != null
                                      ? Text(
                                          post['msg'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        )
                                      : Text(""),
                                ))
                          ],
                        );
                      } else {
                        if (post['type'] == "image") {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    _bottomSheet(post['message_id']);
                                  },
                                  child: _isImage
                                      ? CircularProgressIndicator()
                                      : Container(
                                          height: 200,
                                          width: 200,
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              // color: Colors.deepPurpleAccent,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: CachedNetworkImage(
                                            imageUrl: post['doc'],
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )))
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _bottomSheet(post['message_id']);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black)),
                                  child: post['msg'] != null
                                      ? Text(
                                          post['msg'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        )
                                      : Text(""),
                                ))
                          ],
                        );
                      }
                    },

                    // print(messages);
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.emoji_emotions_outlined),
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                setState(() {
                                  isShowSticker = !isShowSticker;
                                });
                              }),
                          Flexible(
                            child: Container(
                              //height: 40,
                              //   color: Colors.white,
                              margin: EdgeInsets.only(
                                  left: 0.0,
                                  right: 0.0,
                                  top: 0.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: textController,
                                onTap: () {
                                  Timer(
                                      Duration(milliseconds: 300),
                                      () => _scrollController.jumpTo(
                                          _scrollController
                                              .position.maxScrollExtent));
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: false,
                                    contentPadding:
                                        EdgeInsets.only(top: 10, left: 10),
                                    hintText: "Enter Message",
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.black26)),
                              ),
                            ),
                          ),
                          _enterText
                              ? Container()
                              : IconButton(
                                  icon: Icon(Icons.attach_file),
                                  onPressed: () {
                                    getGalleryImage(context);
                                  }),
                          _enterText
                              ? IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    if (textController.text.isNotEmpty) {
                                      _sendMessage(textController.text);

                                      this.setState(() =>
                                          messages.add(textController.text));
                                      textController.text = '';
                                    }
                                  })
                              : Container(),
                        ],
                      ),
                    ),
                    // (isShowSticker
                    //     ? Container(
                    //         height: 220,
                    //         // color: Colors.black26,
                    //         child: buildSticker(appState),
                    //       )
                    //     : Container()),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _addSendImageWithMessage({BuildContext context, File image}) async {
    setState(() {
      _isImage = true;
    });

    print(image);
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
    var uri = Uri.parse(Constants.url + Constants.sendMessage);
    print(uri);
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('doc', stream, length,
        filename: image.path.split('/').last);

    // add file to multipart
    request.files.add(multipartFile);
    print(multipartFile.filename);
    request.fields.addAll({
      "channel_id": widget.channelId.toString(),
      "msg": "",
      "type": "image",
      "authID": appState.user.userId.toString(),
    });

    request.headers.addAll({
      "Authorization": "Bearar " + appState.user.token,
    });
    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      Map<String, dynamic> user = json.decode(value);
      print(user);
      print("User Image Data");

      if (user['success'] == true) {
        dynamic data = user['chat'];

        print(data['group_id']);
        print("Group Id Data");

        if (widget.channelId == null) {
          widget.channelId = data['group_id'];
        }

        if (socketIO != null) {
          socketIO.sendMessage(
              "message",
              json.encode({
                'msg': data['msg'],
                "group_id": int.parse(data['group_id']),
                "created_by": int.parse(data['created_by']),
                "doc": data['doc'],
                "type": data['type'],
                "pet_img": appState.petDetails.image
              }));
        }

        setState(() {
          _isImage = false;
        });
      } else {
        setState(() {
          _isImage = false;
        });
      }

      print("sdsjd");
    }).onError((error) {
      print(error);
      setState(() {
        _isImage = false;
      });
      print("sdsjd");
    });
  }

  _sendMessage(String message) {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.sendMessage, body: {
      "channel_id": widget.channelId,
      "msg": message,
      "authID": appState.user.userId,
      "receiver_id": widget.recieverId,
      "doc": ""
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);

      print("chat message");
      print(message);

      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        dynamic data = extracted['chat'];

        if (widget.channelId == null) {
          widget.channelId = data['group_id'];
        }

        if (socketIO != null) {
          socketIO.sendMessage(
              "message",
              json.encode({
                'msg': data['msg'],
                "group_id": data['group_id'],
                "created_by": data['created_by'],
              }));
        }

        textController.clear();
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  // Widget buildSticker(AppState appState) {
  //   return EmojiPicker(
  //     rows: 3,
  //     columns: 7,
  //     buttonMode: ButtonMode.CUPERTINO,
  //     recommendKeywords: ["racing", "horse"],
  //     numRecommended: 10,
  //     onEmojiSelected: (emoji, category) {
  //       textController.text = emoji.emoji;
  //       print(emoji.emoji);
  //     },
  //   );
  // }

  _deleteChat({int id}) {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.deleteMessage, body: {
      "message_id": id
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      print("chat List");
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        for (var i = 0; i < _chatMessage.length; i++) {
          if (_chatMessage[i]['message_id'] == id) {
            _chatMessage.removeAt(i);
            setState(() {});
          }
        }
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  _bottomSheet(int id) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 60,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              margin: const EdgeInsets.only(
                  top: 5, left: 0.0, right: 0.0, bottom: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _deleteChat(id: id);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.delete_forever),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 20, right: 10, bottom: 10.0),
                            child: Text(
                              "Delete",
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    ),
                  )
                ],
              ));
        });
  }
}
