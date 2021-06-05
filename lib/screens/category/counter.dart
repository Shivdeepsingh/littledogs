import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

import 'order.dart';

class ListItem extends StatefulWidget {
  ListItem(
      {this.id,
      this.image,
      this.price,
      this.title,
      this.quantity,
      this.cardId});

  String title;
  String image;
  int price;
  int id;
  int cardId;
  int quantity;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListItemState();
  }
}

class ListItemState extends State<ListItem> {
  int _itemCount = 1;
  int cartTotal = 0;

  NetworkUtil _networkUtil = NetworkUtil();

  _removeFromCard({int cardId, int item_id}) {
    print(item_id);
    print(cardId);

    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.post(Constants.url + Constants.removeCardItem, body: {
      "card_id": cardId
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);

      print("Remove Card data");
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        if (appState.cart.cartDetail.length != 0) {
          for (var i = 0; i < appState.cart.cartDetail.length; i++) {
            print(appState.cart.cartDetail[i]['item_id']);
            if (appState.cart.cartDetail[i]['item_id'] == item_id) {
              appState.cart.cartDetail.removeAt(i);
              appState.notifyChange();
              print("Delete");
            }
          }

          for (var i = 0; i < appState.cart.cart.length; i++) {
            print(appState.cart.cart[i]['item_id']);
            if (appState.cart.cart[i]['item_id'] == item_id) {
              appState.cart.cart.removeAt(i);
              appState.notifyChange();
              print("Delete");
            }
          }
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
                  widget.image != null
                      ? Container(
                          width: 100,
                          height: 80,
                          child: Image.network(widget.image),
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
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: widget.price != null
                            ? Text(
                                r"$" + widget.price.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )
                            : Text(""),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      children: <Widget>[
                        _itemCount != 1
                            ? new IconButton(
                                icon: new Icon(
                                  Icons.remove,
                                ),
                                onPressed: () => setState(() {
                                  _itemCount--;
                                  takeNumber(
                                      _itemCount, widget.price, appState);
                                }),
                              )
                            : new Container(),
                        _itemCount == 1
                            ? SizedBox(
                                width: 10,
                              )
                            : Container(),
                        new Text(_itemCount.toString()),
                        new IconButton(
                            icon: new Icon(Icons.add),
                            onPressed: () => setState(() {
                                  _itemCount++;
                                  takeNumber(
                                      _itemCount, widget.price, appState);
                                }))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  print(widget.id);
                  print(widget.cardId);
                  _removeFromCard(item_id: widget.id, cardId: widget.cardId);
                },
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
                onTap: () {
                  print(_itemCount);
                  print(widget.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Order(
                              quantity: _itemCount,
                              itemId: widget.id,
                              cardId: widget.cardId,
                            )),
                  );
                },
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

  void takeNumber(int text, int price, AppState appState) {
    try {
      cartTotal = 0;
      print(text);
      print(price);

      for (var i = 0; i < appState.cart.cartDetail.length; i++) {
        if (appState.cart.cartDetail[i]['item_price'] == price) {
          appState.cart.cartDetail[i]['item_quantity'] = text;
          appState.notifyChange();
        }

        try {
          cartTotal += (appState.cart.cartDetail[i]['item_price']) *
              (appState.cart.cartDetail[i]['item_quantity']);
          appState.cart.addCardTotalAmount(cartTotal);
          appState.notifyChange();
        } catch (e, s) {
          print(s.toString());
        }
        print(cartTotal.toString());
      }

      print(appState.cart.cartDetail);
    } catch (e, s) {
      print(s.toString());
    }
  }
}
