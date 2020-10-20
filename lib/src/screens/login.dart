import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../widgets/pageBreak.dart';
import '../widgets/validation.dart';
import '../widgets/plainText.dart';
import '../widgets/titleText.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(userBloc.email),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(

          // Put in the center of the screen
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            TitleText("Let's Hang!", bigger: true),
            _message(),
            PageBreak(60.0),
            _passwordField(userBloc),
            Validation(),
            _submit(context, userBloc),
          ],
        ),
      ),
    );
  }


  Widget _message() {
    return Column(
      children: <Widget>[
        PlainText("Welcome back!"),
        PlainText("Enter your password to login."),
      ],
    );
  }


  Widget _passwordField(UserBloc userBloc) {
    return TextField(
      obscureText: true,
      onChanged: (value) => userBloc.password = value,
      decoration: InputDecoration(
        hintText: 'Password',
        labelText: 'Password',
      ),
    );
  }


  Widget _submit(BuildContext context, UserBloc userBloc) {
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () {
        userBloc.loginUser(context);
      },
    );
  }
}