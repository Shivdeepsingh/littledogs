import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:provider/provider.dart';

import 'info.dart';

class DogColor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DogColorState();
  }
}

class DogColorState extends State<DogColor> {
 // var color = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  double height = 50;
  String value ="";

  List<String> _colors =['Brown','Red',"Dark and light chocolate","Gold and yellow","Cream","Fawn","Black","Blue","Grey","White","Black and Tan","Black and white","Tricolor","Blue merle tricolor","Red merle","Blenheim (Red-brown and white)","Tuxedo","Tuxedo Collie mix","Liver-ticked","Dark orange sable","Hairless","Sable"];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.register.dogBreed);
    print(appState.register.dogAge);
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (validateAndSave()) {
            setState(() {
              height = 50;
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Info()),
            );
            appState.register.addDogColor(value);
            appState.register.addScreen("details");
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
                      margin: EdgeInsets.only(top: 50, left: 30, bottom: 0.0),
                      alignment: Alignment.topLeft,
                      child: Text("Dog color"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      padding: EdgeInsets.only(left: 10),
                      margin: EdgeInsets.only(
                          left: 30, right: 30, top: 20.0, bottom: 10),
                      child:   DropdownButton<String>(
                        isExpanded: true,
                        // value: value,
                        hint: value == "" ?Text("Choose Dog Color",style: TextStyle(color: Colors.black45),):Text(value,style: TextStyle(color: Colors.black45),),
                        items: _colors.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_value) {
                          appState.register.addDogColor(_value);
                          setState(() {
                            value = _value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
