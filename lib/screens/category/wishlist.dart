import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:provider/provider.dart';

class WishList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WishListState();
  }
}

class WishListState extends State<WishList> {
  int _itemCount = 1;
  Widget cartList({AppState appState, int index}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  appState.products.wishListDetail[index]['item_img'] != null
                      ? Container(
                          width: 100,
                          height: 80,
                          child: Image.network(appState
                              .products.wishListDetail[index]['item_img']),
                        )
                      : Container(
                          width: 100,
                          height: 80,
                        ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: appState.products.wishListDetail[index]
                                    ['item_title'] !=
                                null
                            ? Text(
                                appState.products.wishListDetail[index]
                                    ['item_title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )
                            : Text(""),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: appState.products.wishListDetail[index]
                                    ['item_price'] !=
                                null
                            ? Text(
                                r"$" +
                                    appState.products
                                        .wishListDetail[index]['item_price']
                                        .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )
                            : Text(""),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                child: Container(
                  //   alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(left: 0.0, top: 0.0),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Delete",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          border: Border.all(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  //   alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(left: 0.0, top: 0.0),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Buy Now",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          border: Border.all(color: Colors.black)),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WishList",
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
      ),
      body: appState.products.wishListDetail.length != 0
          ? ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: appState.products.wishListDetail.length,
              itemBuilder: (BuildContext context, int index) {
                return cartList(appState: appState, index: index);
              })
          : Container(
              child: Center(
                child: Text("No Orders"),
              ),
            ),
    );
  }
}
