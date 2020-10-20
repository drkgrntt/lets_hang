import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../widgets/validation.dart';
import '../widgets/plainText.dart';
import '../widgets/titleText.dart';
import '../widgets/hangoutForm.dart';


class Add extends StatefulWidget {

  final String friendsId;

  Add(this.friendsId);

  @override
  State<StatefulWidget> createState() {
    return _AddState(friendsId);
  }
}


class _AddState extends State<Add> {

  final String friendsId;

  String _title = '';
  String _description = '';
  String _location = '';
  int _attendeeLimit = 0;
  DateTime _dateTime = DateTime.now();
  List<String> _selectedGroups = [];


  _AddState(this.friendsId);


  @override
  initState() {
    super.initState();
    _selectedGroups.add(friendsId);
  }


  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(20.0),
          child: Column(

            // Put in the center of the screen
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              TitleText("Add a Hangout!", bigger: true),
              HangoutForm(
                title: _title,
                description: _description,
                location: _location,
                attendeeLimit: _attendeeLimit,
                dateTime: _dateTime,
                setState: (key, value) {
                  switch (key) {
                    case 'title':
                      setState(() => _title = value);
                      break;
                    case 'description':
                      setState(() => _description = value);
                      break;
                    case 'location':
                      setState(() => _location = value);
                      break;
                    case 'attendeeLimit':
                      setState(() => _attendeeLimit = value);
                      break;
                    case 'dateTime':
                      setState(() => _dateTime = value);
                      break;
                  }
                },
              ),
              _groupSelectField(userBloc),
              Validation(),
              _submit(userBloc),
            ],
          ),
        ),
      ],
    );
  }


  Widget _groupSelectField(UserBloc userBloc) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          TitleText('Start inviting groups'),
          ..._groups(userBloc),
        ],
      ),
    );
  }


  List<Widget> _groups(UserBloc userBloc) {
    return userBloc.currentUser.groups.map((group) {
      return Row(
        children: <Widget>[
          Checkbox(
            value: _selectedGroups.indexOf(group.id) != -1,
            onChanged: (checked) {
              if (checked) {
                setState(() => _selectedGroups.add(group.id));
              } else {
                setState(() => _selectedGroups.remove(group.id));
              }
            },
          ),
          PlainText(group.title),
        ],
      );
    }).toList();
  }


  Widget _submit(UserBloc userBloc) {
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () {
        userBloc.createHangout(
          _title,
          _description,
          _location,
          _attendeeLimit,
          _dateTime,
          _selectedGroups
        );
      },
    );
  }
}