import 'package:flutter/material.dart';

class Order extends ChangeNotifier {
  List<Map<String, dynamic>> _order = [];

  List<Map<String, dynamic>> get order => _order;

  List<Map<String, dynamic>> _orderDetail = [];

  List<Map<String, dynamic>> get orderDetail => _orderDetail;

  int get orderId => _orderId;
  int _orderId;

  void addOrderId(int text) {
    _orderId = text;
  }

  int _itemId;

  void addItemId(int text) {
    _itemId = text;
  }

  String _orderName = "";

  void addOrderName(String text) {
    _orderName = text;
  }

  int _orderQuantity;

  void addOrderQuantity(int text) {
    _orderQuantity = text;
  }

  int _orderPrice;

  void addOrderPrice(int text) {
    _orderPrice = text;
  }

  String _address = "";

  void addAddress(String text) {
    _address = text;
  }

  int _pinCode;

  void addPinCode(int text) {
    _pinCode = text;
  }

  String _countryCode = "";
  void addCountryCode(String text) {
    _countryCode = text;
  }

  String _phoneNumber = "";
  void addPhone(String text) {
    _phoneNumber = text;
  }

  String _city = "";
  void addCity(String text) {
    _city = text;
  }

  String _state = "";
  void addState(String text) {
    _state = text;
  }

  String _country = "";
  void addCountry(String text) {
    _country = text;
  }

  String _orderNumber = "";
  void addOrderNumber(String text) {
    _orderNumber = text;
  }

  String _status = "";
  void addStatus(String text) {
    _status = text;
  }

  String _paymentMode = "";
  void addpaymentMode(String text) {
    _paymentMode = text;
  }

  String _createdAt = "";

  void addCreatedAt(String text) {
    _createdAt = text;
  }

  String _itemTitle = "";
  void addItemTitle(String text) {
    _itemTitle = text;
  }

  String _itemImg;

  void addItemImage(String text) {
    _itemImg = text;
  }

  int _itemPrice;

  int get itemPrice => _itemPrice;

  void addItemPrice(int text) {
    _itemPrice = text;
  }

  int get itemId => _itemId;

  String get orderName => _orderName;

  int get orderQuantity => _orderQuantity;

  int get orderPrice => _orderPrice;

  String get address => _address;

  int get pinCode => _pinCode;

  String get countryCode => _countryCode;

  String get phoneNumber => _phoneNumber;

  String get city => _city;

  String get state => _state;

  String get country => _country;

  String get orderNumber => _orderNumber;

  String get status => _status;

  String get paymentMode => _paymentMode;

  String get createdAt => _createdAt;

  String get itemTitle => _itemTitle;

  String get itemImg => _itemImg;
}
