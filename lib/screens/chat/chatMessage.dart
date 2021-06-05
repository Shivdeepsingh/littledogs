import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  ChatMessage({this.message});
  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      //  this.type == "sent" ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        new Card(
          ///  color: this.type == "sent" ? Colors.green : Colors.blue,
          child: new Padding(
            padding: new EdgeInsets.all(7.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(this.message),
                new Text('17:00'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
