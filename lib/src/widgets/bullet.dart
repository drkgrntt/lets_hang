import 'package:flutter/material.dart';


class Bullet extends StatelessWidget {

  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(right: 6.0),
      height: 6.0,
      width: 6.0,
      decoration: BoxDecoration(
        color: Theme.of(context).textTheme.bodyText2.color,
        shape: BoxShape.circle,
      ),
    );
  }
}