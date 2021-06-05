import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/screens/tabscreen.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.pinkAccent, width: 2)),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://p.kindpng.com/picc/s/49-496597_dog-png-fluffy-teacup-pomeranian-white-background-transparent.png"),
                    maxRadius: 45,
                    minRadius: 35,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 45,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 30, bottom: 10),
                        child: TextFormField(
                          onTap: () {},
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
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 10),
                              hintText: "Dog Name",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black26)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 45,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0.0, bottom: 10),
                        child: TextFormField(
                          onTap: () {},
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
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 10),
                              hintText: "Dog Breed",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black26)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 45,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0.0, bottom: 10),
                        child: TextFormField(
                          onTap: () {},
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
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 10),
                              hintText: "Dog Age",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black26)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 45,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0.0, bottom: 10),
                        child: TextFormField(
                          onTap: () {},
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
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 10),
                              hintText: "Dog Color",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black26)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 45,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0.0, bottom: 10),
                        child: TextFormField(
                          onTap: () {},
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
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 10),
                              hintText: "City",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black26)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 50,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0.0, bottom: 10),
                        child: TextFormField(
                          onTap: () {},
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
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 10),
                              hintText: "State",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black26)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 45,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0.0, bottom: 10),
                        child: TextFormField(
                          onTap: () {},
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
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 10),
                              hintText: "Country",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black26)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 45,
                        //   color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0.0, bottom: 10),
                        child: TextFormField(
                          onTap: () {},
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
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 10),
                              hintText: "ZipCode",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black26)),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TabScreen()),
                    );
                    // if (_switchValue == true) {
                    //   Navigator.pushNamed(context, '/dashboardOwner');
                    // } else {
                    //   Navigator.pushNamed(context, '/dashboardUser');
                    // }
                  },
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 0.0, top: 20, bottom: 30),
                    alignment: Alignment.center,
                    color: Color(0xFF0e70be),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
