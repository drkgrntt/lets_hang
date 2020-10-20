import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../widgets/pageBreak.dart';
import '../widgets/validation.dart';
import '../widgets/plainText.dart';
import '../widgets/titleText.dart';

class Welcome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(

          // Put in the center of the screen
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            TitleText("Let's Hang!", bigger: true),
            PlainText("Enter your email to get started."),
            PageBreak(40.0),
            _emailField(userBloc),
            Validation(),
            _submit(context, userBloc),
          ],
        ),
      ),
    );
  }


  Widget _emailField(UserBloc userBloc) {
    return TextField(
      onChanged: (value) => userBloc.email = value,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'you@example.com',
        labelText: 'email',
      ),
    );
  }


  Widget _submit(BuildContext context, UserBloc userBloc) {
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () {
        userBloc.checkEmail(context);
      },
    );
  }
}