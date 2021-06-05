import 'package:flutter/cupertino.dart';

class OtherUser extends ChangeNotifier {
  String _image = "";
  String _email = "";
  String _password = "";
  String _dogName = "";
  String _dogBreed = "";
  String _dogAge = "";
  String _dogColor = "";
  String _city = "";
  String _country = "";
  String _gender = "";
  String _concern = "";
  int _requestId;

  int _petId;

  List<Map<String, dynamic>> _requestList = [];

  int get requestId => _requestId;

  List<Map<String, dynamic>> get requestList => _requestList;

  List<Map<String, dynamic>> _followerList = [];

  List<Map<String, dynamic>> get followerList => _followerList;

  List<Map<String, dynamic>> _followerListDetail = [];

  List<Map<String, dynamic>> get followerListDetail => _followerListDetail;

  List<Map<String, dynamic>> _followingList = [];

  List<Map<String, dynamic>> get followingList => _followingList;

  List<Map<String, dynamic>> _followingListDetail = [];

  List<Map<String, dynamic>> get followingListDetail => _followingListDetail;

  var requestStatus = List<bool>();

  void addRequestId(int text) {
    _requestId = text;
  }

  void addPetId(int text) {
    _petId = text;
  }

  int get petId => _petId;

  void addImage(String text) {
    _image = text;
  }

  String get image => _image;

  void addEmail(String text) {
    _email = text;
  }

  void addPassword(String text) {
    _password = text;
  }

  void addDogName(String text) {
    _dogName = text;
  }

  void addDogBreed(String text) {
    _dogBreed = text;
  }

  void addDogColor(String text) {
    _dogColor = text;
  }

  void addDogAge(String text) {
    _dogAge = text;
  }

  void addCity(String text) {
    _city = text;
  }

  void addGender(String text) {
    _gender = text;
  }

  void addCountry(String text) {
    _country = text;
  }

  void addConcern(String text) {
    _concern = text;
  }

  String get dogConcern => _concern;

  String get country => _country;

  String get dogGender => _gender;

  String get city => _city;

  String get dogColor => _dogColor;

  String get dogAge => _dogAge;

  String get dogBreed => _dogBreed;

  String get dogName => _dogName;

  String get password => _password;

  String get email => _email;
}
