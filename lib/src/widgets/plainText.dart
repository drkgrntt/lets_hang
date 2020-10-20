import 'package:flutter/material.dart';


class PlainText extends StatelessWidget {

  final String text;
  final bool inverted;
  final bool underlined;

  PlainText(
    this.text,
    {
      this.inverted = false,
      this.underlined = false
    }
  );

  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: inverted ? Colors.grey[100] : null,
        fontSize: 18.0,
        decoration: underlined ? TextDecoration.underline : null,
      ),
    );
  }
}