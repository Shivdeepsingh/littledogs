import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:provider/provider.dart';

import 'info.dart';

class OtherOptions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OtherOptionsState();
  }
}

class OtherOptionsState extends State<OtherOptions> {
 // var gender = TextEditingController();
 // var concern = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  bool _male = false;
  bool _female = false;

  bool _yes = false;
  bool _no = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  double height = 50;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.register.dogColor);
    print(appState.register.dogAge);
    print(appState.register.dogBreed);
    print(appState.register.dogName);
    print("Dog Details");
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (validateAndSave()) {
            setState(() {
              height = 50;
            });
            // appState.register.addGender(gender.text);
            // appState.register.addConcern(concern.text);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Info()),
            );

            appState.register.addScreen("upload");
            appState.notifyChange();
          } else {
            setState(() {
              height = 70;
            });
          }
        },
        child: Icon(Icons.arrow_forward),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 30, bottom: 10.0),
                    alignment: Alignment.topLeft,
                    child: Text("Gender"),
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'Male',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: _male,
                    onChanged: (value) {
                      appState.register.addGender("Male");

                      setState(() {
                        _male = true;
                        _female = false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'Female',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: _female,
                    onChanged: (value) {
                      appState.register.addGender("Female");
                      setState(() {
                        _male = false;
                        _female = true;
                      });
                    },
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Flexible(
                  //       child: Container(
                  //         height: height,
                  //         //   color: Colors.white,
                  //         margin: EdgeInsets.only(
                  //             left: 20, right: 20, top: 0.0, bottom: 10),
                  //         child: TextFormField(
                  //           controller: gender,
                  //           validator: (val) =>
                  //               val.isEmpty ? 'gender can\'t be empty.' : null,
                  //           decoration: InputDecoration(
                  //             fillColor: Colors.white10,
                  //             filled: true,
                  //             contentPadding:
                  //                 EdgeInsets.only(top: 10, left: 10),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 40, left: 30, bottom: 10.0),
                    alignment: Alignment.topLeft,
                    child: Text("Health Concern"),
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'Yes',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: _yes,
                    onChanged: (value) {
                      appState.register.addConcern("Yes");
                      setState(() {
                        _yes = true;
                        _no = false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'No',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: _no,
                    onChanged: (value) {
                      appState.register.addConcern("No");
                      setState(() {
                        _no = true;
                        _yes = false;
                      });
                    },
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Flexible(
                  //       child: Container(
                  //         height: height,
                  //         //   color: Colors.white,
                  //         margin: EdgeInsets.only(
                  //             left: 20, right: 20, top: 0.0, bottom: 10),
                  //         child: TextFormField(
                  //           controller: concern,
                  //           maxLines: 2,
                  //           decoration: InputDecoration(
                  //             fillColor: Colors.white10,
                  //             filled: true,
                  //             contentPadding:
                  //                 EdgeInsets.only(top: 10, left: 10),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
