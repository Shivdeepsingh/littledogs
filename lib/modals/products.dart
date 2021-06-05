import 'package:flutter/cupertino.dart';

class Products extends ChangeNotifier {
  bool fav = false;

  int _wishListId;

  void addWishListId(int text) {
    _wishListId = text;
  }

  int get wishListId => _wishListId;
  List<Map<String, dynamic>> _productList = [];

  List<Map<String, dynamic>> get productList => _productList;

  List<Map<String, dynamic>> _wishList = [];

  List<Map<String, dynamic>> get wishList => _wishList;

  List<Map<String, dynamic>> _wishListDetail = [];

  List<Map<String, dynamic>> get wishListDetail => _wishListDetail;

  var newData = [];
  List<Map<String, dynamic>> _category = [];

  List<Map<String, dynamic>> get category => _category;
}
