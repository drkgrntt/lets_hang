import 'package:flutter/material.dart';
import '../widgets/titleText.dart';
import '../widgets/plainText.dart';


class Splash extends StatelessWidget {

  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(

          // Put in the center of the screen
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            TitleText("Let's Hang!", bigger: true),
            PlainText("Loading . . ."),
          ],
        ),
      ),
    );
  }
}