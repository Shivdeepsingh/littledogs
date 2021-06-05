import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  int _cartTotalAmount;

  void addCardTotalAmount(int text) {
    _cartTotalAmount = text;
  }

  int get cartTotalAmount => _cartTotalAmount;
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  List<Map<String, dynamic>> _cartDetail = [];

  List<Map<String, dynamic>> get cartDetail => _cartDetail;
}
