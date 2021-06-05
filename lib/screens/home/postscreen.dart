import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PostScreenState();
  }
}

class PostScreenState extends State<PostScreen> {
  StreamController _postsController;

  int count = 1;

  Future fetchPost([howMany = 5]) async {
    final appState = Provider.of<AppState>(context, listen: false);

    final response = await http.post(Uri.parse(Constants.url + Constants.postList),
        body: {"limit": 10, "offset": howMany},
        headers: {"Authorization": "Bearar " + appState.user.token});
    print("post List Data");
    print(response);
    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  loadPosts() async {
    fetchPost().then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  showSnack() {
    return scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('New content loaded'),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    count++;
    print(count);
    fetchPost(count * 5).then((res) async {
      _postsController.add(res);
      showSnack();
      return null;
    });
  }

  @override
  void initState() {
    _postsController = new StreamController();
    loadPosts();
    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: _postsController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('Has error: ${snapshot.hasError}');
        print('Has data: ${snapshot.hasData}');
        print('Snapshot Data ${snapshot.data}');

        if (snapshot.hasError) {
          return Text(snapshot.error);
        }

        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Scrollbar(
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var post = snapshot.data[index];
                        return ListTile(
                          title: Text(post['title']['rendered']),
                          subtitle: Text(post['date']),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return Text('No Posts');
        }
        return Container();
      },
    );
  }
}
