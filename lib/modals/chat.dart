import 'package:flutter/cupertino.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';

class Chat extends ChangeNotifier {
  // SocketIO socketIO;

  List<bool> _checked = [];

  List<bool> get checked => _checked;

  List<Map<String, dynamic>> _chatList = [];

  List<Map<String, dynamic>> get chatList => _chatList;

  List<Map<String, dynamic>> _chatDetail = [];

  List<Map<String, dynamic>> get chatDetail => _chatDetail;
  //
  // List<Map<String, dynamic>> _chatMessage = [];
  //
  // List<Map<String, dynamic>> get chatMessage => _chatMessage;

  List<Map<String, dynamic>> _groupList = [];

  List<Map<String, dynamic>> get groupList => _groupList;

  List<Map<String, dynamic>> _groupDetail = [];

  List<Map<String, dynamic>> get groupDetail => _groupDetail;

  List<Map<String, dynamic>> _memberList = [];

  List<Map<String, dynamic>> get memberList => _memberList;

  List<Map<String, dynamic>> _memberDetail = [];

  List<Map<String, dynamic>> get memberDetail => _memberDetail;
}
