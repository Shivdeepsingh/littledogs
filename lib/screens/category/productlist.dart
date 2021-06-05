import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/category/drawer.dart';
import 'package:littledog/screens/category/showproduct.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

import 'addtocart.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProductListState();
  }
}

class ProductListState extends State<ProductList> {
  NetworkUtil _networkUtil = NetworkUtil();
  bool _loading = false;
  bool _showSheet = false;

  ScrollController _scrollController;

  var text = TextEditingController();
  final client = HttpClient();
  int cartTotal = 0;

  List<Map<String, dynamic>> _newData = [];

  _onChanged(String value) {
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      _newData = appState.products.productList
          .where((row) => row['item_title'].contains(value))
          .toList();

      // _itemNumber = _newData.length;
      // print(_itemNumber);
      print(_newData.length);
    });
  }

  getSearchCat({BuildContext context}) {
    final appState = Provider.of<AppState>(context, listen: false);
    _newData = appState.products.productList
        .where((row) => row['item_title'].contains(text.text))
        .toList();
    setState(() {});
    // _itemNumber = _newData.length;
    //print(_itemNumber);
    print(_newData.length);
  }

  List<Widget> _products() {
    final appState = Provider.of<AppState>(context, listen: false);
    List<Widget> _product = [];
    print(_newData);

    if (_newData.length != 0) {
      for (var data in _newData) {
        print(data);
        print("product list");
        _product.add(GestureDetector(
            onTap: () {
              print(data['item_id']);
              print("ItemId");
              appState.products.fav = false;
              if (appState.products.wishList.length != 0) {
                for (var i = 0; i < appState.products.wishList.length; i++) {
                  if (appState.products.wishList[i]['item_id'] ==
                      data['item_id']) {
                    appState.products.addWishListId(
                        appState.products.wishList[i]['wish_list_id']);
                    appState.products.fav = true;
                  }
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowProduct(
                        image: data['item_img'],
                        title: data['item_title'],
                        desc: data['item_description'],
                        price: data['item_price'],
                        subId: data['sub_category_id'],
                        id: data['item_id'])),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    color: Colors.black12,
                    child: data['item_img'] != null
                        ? CachedNetworkImage(
                            // width: 80,
                            // height: 80,
                            imageUrl: data['item_img'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )
                        : Container(),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: data['item_title'] != null
                              ? Text(
                                  data['item_title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              : Text(""),
                        ),
                        Container(
                          child: data['item_price'] != null
                              ? Text(
                                  "Price: " +
                                      r"$" +
                                      data['item_price'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              : Text("Price: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
      }
    }

    return _product;
  }

  @override
  void initState() {
    super.initState();
    _cartDetail();
    _wishList();
    _getCategories();
    _getProducts();
  }

  // List<bool> activeCategories = [];
  _getCategories() {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.get(Constants.url + Constants.categoryList, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);

      print("Category data");

      var extracted = json.decode(value.body);
      appState.products.category.clear();
      if (extracted['success'] == true) {
        //   activeCategories = List.filled(extracted['response'].length, false);
        for (var data in extracted['response']) {
          appState.products.category.add(data);
          appState.notifyChange();
        }
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  _getProducts() {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.get(Constants.url + Constants.productList + appState.petDetails.dogBreed, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);

      print("Products data");

      var extracted = json.decode(value.body);
      appState.products.productList.clear();
      if (extracted['success'] == true) {
        for (var data in extracted['response']) {
          appState.products.productList.add(data);
          appState.notifyChange();
        }
        getSearchCat(context: context);
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  _cartDetail() {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.get(
        Constants.url + Constants.cartDetail + appState.user.userId.toString(),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearar " + appState.user.token
        }).then((value) {
      print(value.body);

      print("Cart data");
      var extracted = json.decode(value.body);

      appState.cart.cartDetail.clear();
      appState.cart.cart.clear();
      if (extracted['status'] == true) {
        for (var data in extracted['item_detail']) {
          appState.cart.cartDetail.add(data);
          appState.notifyChange();
        }

        for (var data in extracted['detail']) {
          appState.cart.cart.add(data);
          appState.notifyChange();
        }
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  _wishList() {
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.wishList, body: {
      "user_id": appState.user.userId
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);

      print("wishList data");
      var extracted = json.decode(value.body);

      appState.products.wishListDetail.clear();
      appState.products.wishList.clear();
      if (extracted['status'] == true) {
        for (var data in extracted['item_detail']) {
          appState.products.wishListDetail.add(data);
          appState.notifyChange();
        }

        for (var data in extracted['detail']) {
          appState.products.wishList.add(data);
          appState.notifyChange();
        }
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  height: 40,
                  //   color: Colors.white,
                  margin: EdgeInsets.only(
                      left: 0.0, right: 0.0, top: 10.0, bottom: 10),
                  child: TextFormField(
                    controller: text,
                    onChanged: _onChanged,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.0),
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                        hintText: "Search Product",
                        hintStyle:
                            TextStyle(fontSize: 15, color: Colors.black26)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            appState.cart.cart.length != 0
                ? Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.shopping_basket,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          for (var i = 0;
                              i < appState.cart.cartDetail.length;
                              i++) {
                            print(appState.cart.cartDetail[i]['item_price']);
                            print(appState.cart.cartDetail[i]['item_quantity']);
                            try {
                              print(
                                  appState.cart.cartDetail[i]['item_quantity']);
                              cartTotal += appState.cart.cartDetail[i]
                                      ['item_price'] *
                                  appState.cart.cartDetail[i]['item_quantity'];
                              appState.cart.addCardTotalAmount(cartTotal);
                              appState.notifyChange();
                              print(cartTotal.toString());
                            } catch (e, s) {
                              print(s.toString());
                            }
                            print(cartTotal.toString());
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddToCart()),
                          );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black)),
                        child: Text(
                          appState.cart.cart.length.toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      )
                    ],
                  )
                : IconButton(
                    icon: Icon(
                      Icons.shopping_basket,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddToCart()),
                      );
                    },
                  ),
            // IconButton(
            //   icon: Icon(
            //     Icons.filter_list,
            //     color: Colors.black,
            //   ),
            //   onPressed: () {
            //     _modalBottomSheetMenu(context);
            //   },
            // ),
          ],
        ),
        body: _loading
            ? CircularProgressIndicator()
            : Container(
                child: appState.products.productList.length != null
                    ? ListView.builder(
                        itemCount: _products().length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return _products()[index];
                        },
                      )
                    : Container(
                        child: Text("No Products Found"),
                      ),
              ));
  }
}
