import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/category/order.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

import 'addtocart.dart';

class ShowProduct extends StatefulWidget {
  ShowProduct(
      {this.image,
      this.title,
      this.price,
      this.id,
      this.desc,
      this.subId,
      this.wishListId});
  String image;
  int price;
  int subId;
  String title;
  int id;
  String desc = "";
  int wishListId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowProductState();
  }
}

class ShowProductState extends State<ShowProduct> {
  NetworkUtil _networkUtil = NetworkUtil();
  int cartTotal = 0;

  _addToCart() {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.addCart, body: {
      "item_id": widget.id,
      "user_id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      dynamic card = extracted['card'];

      dynamic itemDetail = extracted['item_detail'];

      if (extracted['status'] == true) {
        appState.cart.cartDetail.add({
          "item_img": itemDetail['item_img'],
          "item_title": itemDetail['item_title'],
          "item_price": itemDetail['item_price'],
          "item_id": itemDetail['item_id'],
          "item_quantity": itemDetail['item_quantity'],
          "item_description": itemDetail['item_description'],
        });

        appState.cart.cart.add({
          "add_to_card_id": card['card_id'],
          "item_id": card['item_id'],
        });

        appState.notifyChange();
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  _addWishList() {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.addWishList, body: {
      "item_id": widget.id,
      "user_id": appState.user.userId
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      dynamic card = extracted['wishlist_data'];

      dynamic itemDetail = extracted['item_detail'];

      if (extracted['status'] == true) {
        appState.products.wishListDetail.add({
          "item_img": itemDetail['item_img'],
          "item_name": itemDetail['item_title'],
          "item_price": itemDetail['item_price'],
          "item_id": itemDetail['item_id'],
          "item_quantity": itemDetail['item_quantity'],
          "item_description": itemDetail['item_description'],
        });

        appState.products.addWishListId(card['wish_list_id']);

        appState.products.wishList.add({
          "wish_list_id": card['wish_list_id'],
          "item_id": card['item_id'],
        });

        appState.notifyChange();
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  _removeWisList(int id) {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.removeWishList, body: {
      "wish_list_id": id
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      if (extracted['status'] == true) {
        appState.notifyChange();
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
      appBar: AppBar(
        title: Text(
          "Product Name",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
                          try {
                            cartTotal += (appState.cart.cartDetail[i]
                                    ['item_price']) *
                                (appState.cart.cartDetail[i]['item_quantity']);
                            appState.cart.addCardTotalAmount(cartTotal);
                            // print(appState.cart.cartTotal.toString());
                          } catch (e, s) {
                            print(s.toString());
                          }
                          //    print(appState.cart.cartTotal.toString());
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddToCart()),
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
                    for (var i = 0; i < appState.cart.cartDetail.length; i++) {
                      try {
                        cartTotal += (appState.cart.cartDetail[i]
                                ['item_price']) *
                            (appState.cart.cartDetail[i]['item_quantity']);
                        appState.cart.addCardTotalAmount(cartTotal);
                        appState.notifyChange();
                        // print(appState.cart.cartTotal.toString());
                      } catch (e, s) {
                        print(s.toString());
                      }
                      //   print(appState.cart.cartTotal.toString());
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddToCart()),
                    );
                  },
                ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  // print(_itemCount);
                  print(widget.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Order(
                              quantity: 1,
                              itemId: widget.id,
                            )),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => PaymentOption()),
                  // );
                  // StripePayment.createPaymentMethod(
                  //   PaymentMethodRequest(
                  //     card: testCard,
                  //   ),
                  // ).then((paymentMethod) {
                  //   _scaffoldKey.currentState.showSnackBar(SnackBar(
                  //       content: Text('Received ${paymentMethod.id}')));
                  //   setState(() {
                  //     _paymentMethod = paymentMethod;
                  //   });
                  // }).catchError(setError);
                  // if (Platform.isIOS) {
                  //   _controller.jumpTo(450);
                  // }
                  // StripePayment.paymentRequestWithNativePay(
                  //   androidPayOptions: AndroidPayPaymentRequest(
                  //     totalPrice: "1.20",
                  //     currencyCode: "EUR",
                  //   ),
                  //   applePayOptions: ApplePayPaymentOptions(
                  //     countryCode: 'DE',
                  //     currencyCode: 'EUR',
                  //     items: [
                  //       ApplePayItem(
                  //         label: 'Test',
                  //         amount: '13',
                  //       )
                  //     ],
                  //   ),
                  // ).then((token) {
                  //   setState(() {
                  //     _scaffoldKey.currentState.showSnackBar(
                  //         SnackBar(content: Text('Received ${token.tokenId}')));
                  //     _paymentToken = token;
                  //   });
                  // }).catchError(setError);
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(13),
                    child: Text(
                      "Buy Now",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        border: Border.all(color: Colors.black)),
                  ),
                ),
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  _addToCart();
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(13),
                    child: Text(
                      "Add To Cart",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        border: Border.all(color: Colors.black)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: widget.image != null
                      ? CachedNetworkImage(
                          // width: 80,
                          // height: 80,
                          imageUrl: widget.image,
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
                      : Container(
                          height: 400,
                          color: Colors.black38,
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      appState.products.fav = !appState.products.fav;

                      if (appState.products.fav == false) {
                        _removeWisList(appState.products.wishListId);
                      } else {
                        _addWishList();
                      }
                    });
                  },
                  child: appState.products.fav
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 30,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.favorite_border,
                            size: 30,
                          ),
                        ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: widget.title != null
                      ? Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      : Text(""),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: widget.price != null
                      ? Text(
                          "Price: " + r"$" + widget.price.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      : Text("Price :"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
