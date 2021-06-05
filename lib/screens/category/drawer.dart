import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/category/addtocart.dart';
import 'package:littledog/screens/category/wishlist.dart';
import 'package:littledog/screens/settings/currentorder.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  // List<bool> activeCategories = [];
  // DrawerWidget(this.activeCategories);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DrawerWidgetState();
  }
}

class DrawerWidgetState extends State<DrawerWidget> {
  NetworkUtil _networkUtil = NetworkUtil();

  Widget cat(AppState appState, int index) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  appState.products.productList.clear();
                  for (var data in appState.products.category[index]
                      ['item_as']) {
                    appState.products.productList.add(data);
                    appState.notifyChange();
                  }
                  print("item Products");
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 10.0, bottom: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    appState.products.category[index]['sub_category_name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        // widget.activeCategories.elementAt(index)
        //     ? ListView.builder(
        //         shrinkWrap: true,
        //         itemCount:
        //             appState.products.category[index]['sub_category_as'].length,
        //         itemBuilder: (context, subIndex) {
        //           return Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               GestureDetector(
        //                 onTap: () {
        //                   print(appState.products.category[index]
        //                       ['sub_category_as'][subIndex]['item_as']);
        //                   appState.products.productList.clear();
        //                   for (var data in appState.products.category[index]
        //                       ['sub_category_as'][subIndex]['item_as']) {
        //                     appState.products.productList.add(data);
        //                     appState.notifyChange();
        //                   }
        //                   print("item Products");
        //                   Navigator.pop(context);
        //                 },
        //                 child: Container(
        //                   margin:
        //                       EdgeInsets.only(left: 40, top: 10.0, bottom: 10),
        //                   child: Text(
        //                     appState.products.category[index]['sub_category_as']
        //                         [subIndex]['sub_category_name'],
        //                     style: TextStyle(
        //                         fontWeight: FontWeight.bold, fontSize: 15),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           );
        //         },
        //       )
        //     : Container(),
        // Container(
        //   height: 1,
        //   margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        //   width: MediaQuery.of(context).size.width,
        //   color: Colors.black26,
        // )
      ],
    );
  }

  int cartTotal = 0;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Drawer(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(
                  "Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: appState.products.category.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cat(appState, index);
                    }),
              ),
              GestureDetector(
                onTap: () {
                  for (var i = 0; i < appState.cart.cartDetail.length; i++) {
                    try {
                      cartTotal += (appState.cart.cartDetail[i]['item_price']) *
                          (appState.cart.cartDetail[i]['item_quantity']);
                      appState.cart.addCardTotalAmount(cartTotal);
                      appState.notifyChange();
                      // print(appState.cart.cartTotal.toString());
                    } catch (e, s) {
                      print(s.toString());
                    }
                    //  print(appState.cart.cartTotal.toString());
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddToCart()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Add To Cart",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 1,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                color: Colors.black26,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WishList()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Wish List",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 1,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                color: Colors.black26,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CurrentOrder()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Orders",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 1,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                color: Colors.black26,
              ),
              GestureDetector(
                onTap: () {
                  //  _medList();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Help Center",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 1,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                color: Colors.black26,
              ),
              GestureDetector(
                onTap: () {
                  //  _medList();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "About Us",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
