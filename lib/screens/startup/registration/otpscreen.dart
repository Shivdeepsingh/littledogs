import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:littledog/modals/appstate.dart';
import 'package:littledog/utils/constants.dart';
import 'package:littledog/utils/networkutils.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'info.dart';

class OTPScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OTPScreenState();
  }
}

class OTPScreenState extends State<OTPScreen> {
  final formKey = new GlobalKey<FormState>();

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String _deviceToken ="";


  String smsCode;
  bool _isLoading = false;

  dynamic _user = [];
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  var sms = TextEditingController();

  TextEditingController controller = TextEditingController(text: "");

  NetworkUtil _networkUtil = NetworkUtil();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _loading = false;
  String thisText = "";
  int pinLength = 5;
  bool hasError = false;
  String errorMessage;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _otpVerify() {
    setState(() {
      _loading = true;
    });
    try {
      _networkUtil.post(Constants.url + Constants.verifyOtp, body: {
        "otp": controller.text,
      }, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }).then((value) async {
        print(value.body);
        setState(() {
          _loading = false;
        });
        final appState = Provider.of<AppState>(context, listen: false);
        var extracted = json.decode(value.body);
        print(extracted['status']);
        print(extracted['token']);

        if (extracted['success'] == true) {
          _user = extracted['user'];
          print(_user["user_id"]);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Info()),
          );
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString("email", _user["email"]);
          sharedPreferences.setString("token", extracted['token']);
          sharedPreferences.setInt("userId", _user["user_id"]);
          appState.user.addToken(extracted['token']);
          appState.user.addUserId(_user["user_id"]);
          appState.register.addScreen("info");
          _addDeviceToken(_deviceToken);
          appState.notifyChange();
          print("ncdxnv");
        } else {
          print("ncdxnv");
          final snackBar = SnackBar(
            content: Text(extracted['message']),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }).catchError((error) {
        setState(() {
          _loading = false;
        });
        print(error.toString());
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print(e.toString());
    }
  }

  _addDeviceToken(String token) async {
    final appState = Provider.of<AppState>(context, listen: false);

    _networkUtil.post(Constants.url + Constants.deviceToken, body: {
      "user_id": appState.user.userId,
      "user_device_token": token
    }, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    }).then((value) {
      print(value.body);
      print("Device Token Submit Successfully");
    }).catchError((error) {
      print(error.toString());
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((String token) {
      assert(token != null);
      setState(() {
        //  _homeScreenText = "Push Messaging token: $token";
      });
      _deviceToken = token;

      print(token);
      print("Device Token");
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    var otpForm = Container(
        child: SingleChildScrollView(
      child: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: new Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    "Verification Code".toUpperCase(),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 80),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Text(
                    "Please enter the OTP sent\non your registered Email ID.",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                PinCodeTextField(
                  autofocus: true,
                  controller: controller,
                  hideCharacter: false,
                  highlight: true,
                  highlightColor: Colors.blue,
                  defaultBorderColor: Colors.black,
                  hasTextBorderColor: Colors.green,
                  maxLength: 6,
                  hasError: hasError,
                  maskCharacter: "😎",
                  onTextChanged: (text) {
                    setState(() {
                      hasError = false;
                    });
                  },
                  onDone: (text) {
                    print("DONE $text");
                    print("DONE CONTROLLER ${controller.text}");
                    _otpVerify();
                  },
                  pinBoxWidth: 40,
                  pinBoxHeight: 54,
                  hasUnderline: true,
                  wrapAlignment: WrapAlignment.spaceAround,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 22.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
//                    highlightAnimation: true,
                  highlightAnimationBeginColor: Colors.black,
                  highlightAnimationEndColor: Colors.white12,
                  keyboardType: TextInputType.number,
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 80),
                //   child: new Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         firstTextField(),
                //         secondTextField(),
                //         thirdTextField(),
                //         fourthTextField(),
                //         fifthTextField(),
                //         sixthTextField()
                //       ]),
                // ),
              ],
            ),
          ),
        ),
      ]),
    ));

    // TODO: implement build
    return new Scaffold(
        key: _scaffoldKey,
        appBar: null,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _otpVerify();
          },
          child: _loading
              ? CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : Icon(Icons.arrow_forward),
        ),
        body: new Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
          ),
          child: new Center(
              child: new Container(
            child: otpForm,
            decoration: new BoxDecoration(color: Colors.white),
          )),
        ));
  }
}
