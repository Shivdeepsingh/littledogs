import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String _token = "";
  int _userId;
  int activeTab = -1;
  TabController controller;

  bool requestSend = false;

  bool showData = false;

  List<CameraDescription> cameras;

  List<Map<String, dynamic>> _petList = [];

  List<Map<String, dynamic>> get petList => _petList;

  List<Map<String, dynamic>> _followRequestSend = [];

  List<Map<String, dynamic>> get followRequestSend => _followRequestSend;

  List<Map<String, dynamic>> _followRequestList = [];

  List<Map<String, dynamic>> get followRequestList => _followRequestList;
  List<Map<String, dynamic>> _followRequestDetail = [];

  List<Map<String, dynamic>> get followRequestDetail => _followRequestDetail;

  List<Map<String, dynamic>> _followerList = [];

  List<Map<String, dynamic>> get followerList => _followerList;

  List<Map<String, dynamic>> _followerListDetail = [];

  List<Map<String, dynamic>> get followerListDetail => _followerListDetail;

  List<Map<String, dynamic>> _followingList = [];

  List<Map<String, dynamic>> get followingList => _followingList;

  List<Map<String, dynamic>> _followingListDetail = [];

  List<Map<String, dynamic>> get followingListDetail => _followingListDetail;

  void addToken(String token) {
    _token = token;
  }

  void addUserId(int id) {
    _userId = id;
  }

  String get token => _token;

  int get userId => _userId;
}
