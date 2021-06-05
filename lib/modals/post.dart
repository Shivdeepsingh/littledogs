import 'package:flutter/cupertino.dart';

class Post extends ChangeNotifier {
  int _likesLength;

  void addLikesLength(int text) {
    _likesLength = text;
  }

  int get likesLength => _likesLength;

  List<Map<String, dynamic>> _feedList = [];

  List<Map<String, dynamic>> get feedList => _feedList;

  List<Map<String, dynamic>> _postUser = [];

  List<Map<String, dynamic>> get postUser => _postUser;

  List<Map<String, dynamic>> _commentList = [];

  List<Map<String, dynamic>> get commentList => _commentList;

  List<Map<String, dynamic>> _commentUser = [];

  List<Map<String, dynamic>> get commentUser => _commentUser;

  List<Map<String, dynamic>> _likeList = [];

  List<Map<String, dynamic>> get likeList => _likeList;

  List<Map<String, dynamic>> _likeLength = [];

  List<Map<String, dynamic>> get likeLength => _likeLength;

  List<Map<String, dynamic>> _storyList = [];

  List<Map<String, dynamic>> get storyList => _storyList;

  List<Map<String, dynamic>> _storyDetail = [];

  List<Map<String, dynamic>> get storyDetail => _storyDetail;

  List<Map<String, dynamic>> _newStoryList = [];

  List<Map<String, dynamic>> get newStoryList => _newStoryList;

  List<Map<String, dynamic>> _newStoryDetail = [];

  List<Map<String, dynamic>> get newStoryDetail => _newStoryDetail;
}
