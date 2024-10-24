import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  final String? text;
  final dynamic image;

  CardContent({this.text, this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Container(
                decoration: BoxDecoration(
              image: image,
            )),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            text!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ],
    );
  }
}
