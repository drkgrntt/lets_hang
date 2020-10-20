import 'package:flutter/material.dart';

class PageBreak extends StatelessWidget {

  final double breakSize;

  PageBreak(this.breakSize);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: breakSize));
  }
}