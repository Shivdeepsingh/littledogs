import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/startup/registration/info.dart';
import 'package:provider/provider.dart';

class DogAge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DogAgeState();
  }
}

class DogAgeState extends State<DogAge> {
//  var age = TextEditingController();

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

  List<String> _age = ['1-2',"2-3","3-4","4-5","5-6","6-7","7-8","8-9","9-10","10-11","11-12","12-13","13-14","14-15","15-16"];

  // DateTime currentDate = DateTime.now();
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime pickedDate = await showDatePicker(
  //       context: context,
  //       initialDate: currentDate,
  //       firstDate: DateTime(1995),
  //       lastDate: DateTime(2050));
  //   if (pickedDate != null && pickedDate != currentDate)
  //     setState(() {
  //       print(currentDate);
  //       age.text = currentDate.year.toString() +
  //           "-" +
  //           currentDate.month.toString() +
  //           "-" +
  //           currentDate.day.toString();
  //       currentDate = pickedDate;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.register.dogBreed);
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

            appState.register.addDogAge(value);

            appState.register.addScreen("color");
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
                      child: Text("Dog Age"),
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
                        hint: value == "" ?Text("Choose Dog Age",style: TextStyle(color: Colors.black45),):Text(value,style: TextStyle(color: Colors.black45),),
                        items: _age.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_value) {
                          appState.register.addDogAge(_value);
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
