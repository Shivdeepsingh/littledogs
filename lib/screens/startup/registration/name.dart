import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/screens/startup/registration/info.dart';
import 'package:provider/provider.dart';

class DogName extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DogNameState();
  }
}

class DogNameState extends State<DogName> {
  var name = TextEditingController();
//  var breed = TextEditingController();

  List<String> _breed = ['Labrador Retriever',"German Shepherd Dog","Poodle","Chihuahua","Golden Retriever","Yorkshire Terrier","Dachshund","Beagle",
  "Boxer","Miniature Schnauzer","Shih Tzu","Bulldog","German Spitz","English Cocker Spaniel","Cavalier King Charles Spaniel","French Bulldog",
  "Pug","Rottweiler","English Setter","Maltese","English Springer Spaniel","German Shorthaired Pointer","Staffordshire Bull Terrier",
  "Border Collie","Shetland Sheepdog","Dobermann","West Highland White Terrier","Bernese Mountain Dog","Great Dane","Brittany Spaniel"];

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

  String value = "Labrador Retriever";
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (validateAndSave()) {
            setState(() {
              height = 50;
            });

            appState.register.addDogName(name.text);
            appState.register.addDogBreed(value);
            print(appState.register.dogBreed);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Info()),
            );
            appState.register.addScreen("age");
            appState.notifyChange();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => DogAge()),
            // );
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
                      margin: EdgeInsets.only(top: 80, left: 30, bottom: 0.0),
                      alignment: Alignment.topLeft,
                      child: Text("Dog Name"),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            height: height,
                            //   color: Colors.white,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 0.0, bottom: 10),
                            child: TextFormField(
                              controller: name,
                              validator: (val) => val.isEmpty
                                  ? 'Dog Name can\'t be empty.'
                                  : null,
                              // onChanged: _onChanged,
                              decoration: InputDecoration(
                                fillColor: Colors.white10,
                                filled: true,
                                contentPadding:
                                    EdgeInsets.only(top: 10, left: 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50, left: 30, bottom: 0.0),
                      alignment: Alignment.topLeft,
                      child: Text("Dog Breed"),
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
                      hint: value == "" ?Text("Choose Dog Breed",style: TextStyle(color: Colors.black45),):Text(value,style: TextStyle(color: Colors.black45),),
                      items: _breed.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (_value) {
                        appState.register.addDogBreed(_value);
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
