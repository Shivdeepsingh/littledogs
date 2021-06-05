import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 50,
                      //   color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 30.0, bottom: 10),
                      child: TextFormField(
                        // controller: text,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(7.0),
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            suffixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.only(top: 10, left: 10),
                            hintText: "Search Product",
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black26)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
