import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({Key? key, required this.text, required this.sender})
      : super(key: key);

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              sender[0],
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Expanded(
            child: Column(
          children: [
            Text(
              sender,
              /* style: Theme.of(context).textTheme.subtitle1,*/
              style: TextStyle(color: Colors.white),
            )
                .text
                .subtitle1(context)
                .make()
                .box
                .alignCenter
                .white
                .alignCenterLeft
                .p3
                .makeCentered(),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(
                text.trim(),
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ))
      ],
    );
  }
}
