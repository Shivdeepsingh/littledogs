import 'package:flutter/material.dart';

class Register extends ChangeNotifier {
  String _screen = "";
  String _image = "";
  String _email = "";
  String _password = "";
  String _name = "";
  String _dogName = "";
  String _dogBreed = "";
  String _dogAge = "";
  String _dogColor = "";
  String _city = "";
  String _country = "";
  String _gender = "";
  String _concern = "";
  String _photo = "";

  void addScreen(String text) {
    _screen = text;
  }

  void addImage(String text) {
    _image = text;
  }

  String get image => _image;

  String get screen => _screen;

  void addName(String text) {
    _name = text;
  }

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

  void addPhoto(String text) {
    _photo = text;
  }

  String get photo => _photo;

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
  String get name => _name;
}
