import 'package:flutter/material.dart';


class TitleText extends StatelessWidget {

  final String text;
  final bool bigger;

  TitleText(this.text, { this.bigger = false });

  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: bigger ? 48.0 : 24.0,
        fontWeight: bigger ? FontWeight.w700 : FontWeight.w500,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}