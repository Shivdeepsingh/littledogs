import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/category/showorder.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class CurrentOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CurrentOrderState();
  }
}

class CurrentOrderState extends State<CurrentOrder> {
  NetworkUtil _networkUtil = NetworkUtil();
  bool _loading = false;

  orderList() {
    setState(() {
      _loading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);
    _networkUtil.get(
        Constants.url + Constants.orderList + appState.user.userId.toString(),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearar " + appState.user.token
        }).then((value) {
      print(value.body);
      print("orderList");
      var extracted = json.decode(value.body);

      appState.order.order.clear();
      appState.order.orderDetail.clear();
      if (extracted['status'] == true) {
        for (var data in extracted['detail']) {
          appState.order.order.add(data);
          appState.notifyChange();
        }

        for (var data1 in extracted['item_detail']) {
          appState.order.orderDetail.add(data1);
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
      print(error);
    });
  }

  Widget _orderList(AppState appState, int index) {
    DateTime dateTime =
        DateTime.parse(appState.order.order[index]['createdAt']);
    var dateFormatted = DateFormat("dd-MM-yyyy").format(dateTime);
    print(dateFormatted);
    return GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Row(
                  children: [
                    Container(
                      child: Image.network(
                          appState.order.orderDetail[index]['item_img']),
                      height: 100,
                      width: 120,
                      padding: EdgeInsets.all(15),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                appState.order.orderDetail[index]['item_title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, left: 10),
                              child: Text(
                                dateFormatted,
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          //  alignment: Alignment.topRight,
                          child:
                              appState.order.order[index]['status'] == "pending"
                                  ? Text(
                                      appState.order.order[index]['status']
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    )
                                  : Text(
                                      appState.order.order[index]['status']
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                //  padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text("Buy it Again"),
                      margin: EdgeInsets.only(left: 30),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 0.0, bottom: 0.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.black26,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowOrder(
                              id: appState.order.order[index]['order_id'],
                            )),
                  );
                },
                child: Container(
                  //  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("View Order Details"),
                        margin: EdgeInsets.only(left: 30),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowOrder(
                                      id: appState.order.order[index]
                                          ['order_id'],
                                    )),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 0.0, bottom: 0.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.black26,
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
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
            "Orders",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              )
            : Container(
                child: appState.order.orderDetail.length != 0
                    ? ListView.builder(
                        itemCount: appState.order.orderDetail.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _orderList(appState, index);
                        },
                      )
                    : Center(
                        child: Text("No Orders Yet"),
                      ),
              ));
  }
}
