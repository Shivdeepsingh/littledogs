import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class ShowOrder extends StatefulWidget {
  ShowOrder({this.id});
  int id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowOrderState();
  }
}

class ShowOrderState extends State<ShowOrder> {
  NetworkUtil _networkUtil = NetworkUtil();
  bool _loading = false;

  _orderDetail() {
    setState(() {
      _loading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.orderDetail, body: {
      "order_id": widget.id
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      dynamic detail = extracted['detail'];

      if (extracted['status'] == true) {
        DateTime dateTime = DateTime.parse(detail['createdAt']);
        var dateFormatted = DateFormat("dd-MM-yyyy").format(dateTime);
        print(dateFormatted);
        appState.order.addOrderId(detail['order_id']);
        appState.order.addItemId(detail['item_id']);
        appState.order.addOrderName(detail['order_name']);
        appState.order.addOrderQuantity(detail['order_quantity']);
        appState.order.addOrderPrice(detail['order_price']);
        appState.order.addStatus(detail['status']);
        appState.order.addAddress(detail['address']);
        appState.order.addPinCode(detail['pincode']);
        appState.order.addCountryCode(detail['country_code']);
        appState.order.addPhone(detail['mobile_no']);
        appState.order.addState(detail['state']);
        appState.order.addCity(detail['city']);
        appState.order.addCountry(detail['country']);
        appState.order.addOrderNumber(detail['order_number']);
        appState.order.addpaymentMode(detail['payment_mode']);
        appState.order.addCreatedAt(dateFormatted);
        appState.notifyChange();

        for (var item in extracted['item_detail']) {
          appState.order.addItemImage(item['item_img']);
          appState.order.addItemTitle(item['item_title']);
          appState.order.addItemPrice(item['item_price']);
          appState.notifyChange();
        }
      }
      setState(() {
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      print(error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _orderDetail();
  }

  _orderCancel() {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.orderStatus, body: {
      "order_id": widget.id,
      "status": "Cancel"
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearar " + appState.user.token
    }).then((value) {
      print(value.body);
      var extracted = json.decode(value.body);

      if (extracted['success'] == true) {
        Navigator.of(context).pop();
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
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Order Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  appState.order.status == "pending"
                      ? GestureDetector(
                          onTap: () {
                            _orderCancel();
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            //  width: 105,
                            margin: EdgeInsets.only(bottom: 10, right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)),
                            child: Text(
                              "Order Cancel",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text("Order Date"),
                            ),
                            Container(
                              child: Text(
                                appState.order.createdAt,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text("Order #"),
                            ),
                            Container(
                              child: Text(
                                appState.order.orderNumber,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text("Order total"),
                            ),
                            Container(
                              child: Text(
                                appState.order.orderPrice.toString() +
                                    "(" +
                                    appState.order.orderQuantity.toString() +
                                    "item)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Shipment Details",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Image.network(appState.order.itemImg),
                                  height: 100,
                                  width: 120,
                                  padding: EdgeInsets.all(15),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        appState.order.itemTitle,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("Qty: 1"),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20, bottom: 50),
                              child: Text(
                                r"$" + appState.order.itemPrice.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Payment Information",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Payment Method",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Container(
                          child: Text(
                            appState.order.paymentMode,
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Shipping Address",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            appState.order.address,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Container(
                          child: Text(
                            appState.order.city,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          child: Text(
                            appState.order.state,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          child: Text(
                            appState.order.country,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          child: Text(
                            appState.order.pinCode.toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          child: Text(
                            appState.order.countryCode +
                                "\t" +
                                appState.order.phoneNumber,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Order Summary",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Items"),
                            ),
                            Container(
                              child: Text(
                                  r"$" + appState.order.itemPrice.toString()),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("packaging & Packing:"),
                            ),
                            Container(
                              child: Text(r"$" + "0"),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Total before Tax:"),
                            ),
                            Container(
                              child: Text(
                                  r"$" + appState.order.itemPrice.toString()),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Tax:"),
                            ),
                            Container(
                              child: Text(r"$" + "0"),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Total"),
                            ),
                            Container(
                              child: Text(
                                  r"$" + appState.order.orderPrice.toString()),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Order Total",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: Text(
                                r"$" + appState.order.itemPrice.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
