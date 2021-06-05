import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/services/services.dart';
import 'package:provider/provider.dart';

import 'category/productlist.dart';
import 'home/home.dart';
import 'myprofile/mainprofile.dart';
import 'notifications/notifications.dart';
import 'uploads/upload.dart';

class TabScreen extends StatefulWidget {
  TabScreen({this.onSignOut});

  final VoidCallback onSignOut;
  @override
  TabScreenState createState() {
    return new TabScreenState();
  }
}

class TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.user.controller = new TabController(length: 6, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    final appState = Provider.of<AppState>(context, listen: false);
    appState.user.controller.dispose();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    //  SystemNavigator.pop();
    print("data end");
    return true; // return true if the route to be popped
  }

  double height;
  @override
  Widget build(BuildContext ctxt) {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.user.activeTab > 0) {
      appState.user.controller.animateTo(appState.user.activeTab);
      appState.user.activeTab = -1;
    }
    return WillPopScope(
        child: MaterialApp(
          home: DefaultTabController(
            length: 6,
            child: Scaffold(
              bottomNavigationBar: new TabBar(
                isScrollable: false,
                controller: appState.user.controller,
                tabs: [
                  Tab(
                    icon: Image.asset(
                      "assets/home.png",
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/shop.png",
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/search.png",
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/upload.png",
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/notify.png",
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/profile.png",
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,

                indicatorSize: TabBarIndicatorSize.tab,
                // indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.black,
              ),
              body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: appState.user.controller,
                  children: [
                    Home(),
                    ProductList(),
                    Services(),
                    Upload(),
                    Notifications(),
                    MainProfile(),
                  ]
                  //
                  ),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        onWillPop: _willPopCallback);
  }
}
