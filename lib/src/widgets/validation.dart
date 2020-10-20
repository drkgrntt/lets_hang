import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';


class Validation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    if (userBloc.validationMessage == '') {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          userBloc.validationMessage,
          style: TextStyle(
            color: Theme.of(context).errorColor,
            fontStyle: FontStyle.italic,
            fontSize: 14.0,
          ),
        ),
      );
    }
  }
}