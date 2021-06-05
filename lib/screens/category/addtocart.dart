import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/category/counter.dart';
import 'package:provider/provider.dart';

class AddToCart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddToCartState();
  }
}

class AddToCartState extends State<AddToCart> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart List",
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
      body: appState.cart.cartDetail.length != 0
          ? ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: appState.cart.cartDetail.length,
              itemBuilder: (BuildContext context, int index) {
                return ListItem(
                    image: appState.cart.cartDetail[index]['item_img'],
                    title: appState.cart.cartDetail[index]['item_title'],
                    price: appState.cart.cartDetail[index]['item_price'],
                    id: appState.cart.cartDetail[index]['item_id'],
                    cardId: appState.cart.cart[index]['card_id'],
                    quantity: appState.cart.cartDetail[index]['item_quantity']);
              })
          : Container(
              child: Center(
                child: Text("No Orders"),
              ),
            ),
    );
  }
}
