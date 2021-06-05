import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/category/showorder.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class Order extends StatefulWidget {
  Order({this.quantity, this.itemId, this.cardId});
  int itemId;
  int quantity;
  int cardId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderState();
  }
}

class OrderState extends State<Order> {
  int _radioValue = 0;
  var address = TextEditingController();
  var pinCode = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var country = TextEditingController();
  var countryCode = TextEditingController();
  var phoneNumber = TextEditingController();
  bool _loading = false;

  NetworkUtil _networkUtil = NetworkUtil();

  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _addOrder() {
    if (validateAndSave()) {
      setState(() {
        _loading = true;
      });
      final appState = Provider.of<AppState>(context, listen: false);
      _networkUtil.post(Constants.url + Constants.addOrder, body: {
        "item_id": widget.itemId,
        "order_quantity": widget.quantity,
        "address": address.text,
        "pincode": pinCode.text,
        "city": city.text,
        "state": state.text,
        "country": country.text,
        "country_code": countryCode.text,
        "mobile_no": phoneNumber.text,
        "user_id": appState.user.userId,
        "payment_mode": "Cash"
      }, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearar " + appState.user.token
      }).then((value) {
        print(value.body);
        var extracted = json.decode(value.body);
        setState(() {
          _loading = false;
        });
        if (extracted['status'] == true) {
          _removeFromCard(cardId: widget.cardId, item_id: widget.itemId);

          final snackBar = SnackBar(
            content: Text(extracted['message']),
          );
          _scaffoldkey.currentState.showSnackBar(snackBar);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowOrder(
                      id: extracted["order"]['order_id'],
                    )),
          );
        } else {
          final snackBar = SnackBar(
            content: Text(extracted['message']),
          );
          _scaffoldkey.currentState.showSnackBar(snackBar);
        }

        print("Order Confirmed");
      }).catchError((error) {
        setState(() {
          _loading = false;
        });
        final snackBar = SnackBar(
          content: Text(error),
        );
        _scaffoldkey.currentState.showSnackBar(snackBar);
        print(error);
      });
    }
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          print(_radioValue);
          break;
        case 1:
          print(_radioValue);
          break;
      }
    });
  }

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
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        title: Text(
          "Order",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 30, bottom: 0.0),
                alignment: Alignment.topLeft,
                child: Text("Address"),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      //  height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20.0, bottom: 10),
                      child: TextFormField(
                        controller: address,
                        maxLines: 4,
                        validator: (val) =>
                            val.isEmpty ? 'Address can\'t be empty.' : null,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(7.0),
                            ),
                          ),
                          fillColor: Colors.white10,
                          filled: true,
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 30, bottom: 0.0),
                alignment: Alignment.topLeft,
                child: Text("Pin Code"),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      //  height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20.0, bottom: 10),
                      child: TextFormField(
                        controller: pinCode,
                        validator: (val) =>
                            val.isEmpty ? 'Pin Code can\'t be empty.' : null,
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(7.0),
                            ),
                          ),
                          fillColor: Colors.white10,
                          filled: true,
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 30, bottom: 0.0),
                alignment: Alignment.topLeft,
                child: Text("City"),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      //  height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20.0, bottom: 10),
                      child: TextFormField(
                        controller: city,
                        maxLines: 1,
                        validator: (val) =>
                            val.isEmpty ? 'City can\'t be empty.' : null,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(7.0),
                            ),
                          ),
                          fillColor: Colors.white10,
                          filled: true,
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 30, bottom: 0.0),
                alignment: Alignment.topLeft,
                child: Text("State"),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      //  height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20.0, bottom: 10),
                      child: TextFormField(
                        controller: state,
                        maxLines: 1,
                        validator: (val) =>
                            val.isEmpty ? 'State can\'t be empty.' : null,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(7.0),
                            ),
                          ),
                          fillColor: Colors.white10,
                          filled: true,
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 30, bottom: 0.0),
                alignment: Alignment.topLeft,
                child: Text("Country"),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      //  height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20.0, bottom: 10),
                      child: TextFormField(
                        controller: country,
                        maxLines: 1,
                        validator: (val) =>
                            val.isEmpty ? 'Country can\'t be empty.' : null,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(7.0),
                            ),
                          ),
                          fillColor: Colors.white10,
                          filled: true,
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 30, bottom: 0.0),
                alignment: Alignment.topLeft,
                child: Text("Phone Number"),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 70,
                    //  height: 50,
                    //   color: Colors.white,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, top: 20.0, bottom: 10),
                    child: TextFormField(
                      controller: countryCode,
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      // onChanged: _onChanged,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(7.0),
                          ),
                        ),
                        fillColor: Colors.white10,
                        filled: true,
                        hintText: "+1",
                        hintStyle:
                            TextStyle(color: Colors.black26, fontSize: 18),
                        contentPadding: EdgeInsets.only(top: 10, left: 20),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      //  height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 0.0, right: 20, top: 20.0, bottom: 10),
                      child: TextFormField(
                        controller: phoneNumber,
                        maxLines: 1,
                        validator: (val) => val.isEmpty
                            ? 'Phone Number can\'t be empty.'
                            : null,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(7.0),
                            ),
                          ),
                          fillColor: Colors.white10,
                          filled: true,
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Container(
              //   margin: EdgeInsets.only(top: 10, left: 30, bottom: 0.0),
              //   alignment: Alignment.topLeft,
              //   child: Text("Choose payment Option"),
              // ),
              // Row(
              //   children: [
              //     SizedBox(
              //       width: 20,
              //     ),
              //     new Radio(
              //       value: 0,
              //       groupValue: _radioValue,
              //       onChanged: _handleRadioValueChange,
              //     ),
              //     new Text('Cash On Delivery'),
              //   ],
              // ),
              // Row(
              //   children: [
              //     SizedBox(
              //       width: 20,
              //     ),
              //     new Radio(
              //       value: 1,
              //       groupValue: _radioValue,
              //       onChanged: _handleRadioValueChange,
              //     ),
              //     new Text('Online'),
              //   ],
              // ),
              GestureDetector(
                onTap: () {
                  _addOrder();
                },
                child: _loading
                    ? CircularProgressIndicator()
                    : Container(
                        width: 150,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                        alignment: Alignment.center,
                        color: Color(0xFF0e70be),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
