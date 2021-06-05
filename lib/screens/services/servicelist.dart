import 'package:flutter/material.dart';

class ServiceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ServiceListState();
  }
}

class ServiceListState extends State<ServiceList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          //  alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        //  height: 40,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 100.0, bottom: 10),
                        child: TextFormField(
                          //  controller: text,
                          //onChanged: _onChanged,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(25.0),
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(Icons.search),
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 10),
                              hintText: "Search PinCode",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black26)),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    color: Color(0xFF0e70be),
                    child: Text(
                      "Search",
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
        ));
  }
}
