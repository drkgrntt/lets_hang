import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../widgets/pageBreak.dart';
import '../widgets/validation.dart';
import '../widgets/plainText.dart';
import '../widgets/titleText.dart';

class Register extends StatelessWidget {

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
            PageBreak(20.0),
            _firstNameField(userBloc),
            _lastNameField(userBloc),
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
        PlainText("Welcome!"),
        PlainText("Enter some info to login."),
      ],
    );
  }


  Widget _firstNameField(UserBloc userBloc) {
    return TextField(
      onChanged: (value) => userBloc.firstName = value,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'First Name',
      ),
    );
  }


  Widget _lastNameField(UserBloc userBloc) {
    return TextField(
      onChanged: (value) => userBloc.lastName = value,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Last Name',
      ),
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
        userBloc.createUser(context);
      },
    );
  }
}