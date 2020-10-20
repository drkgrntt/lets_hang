import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../models/hangout.dart';
import '../widgets/hangoutForm.dart';
import '../widgets/validation.dart';
import '../widgets/titleText.dart';
import '../widgets/pageBreak.dart';
import '../widgets/userListItem.dart';


class EditHangout extends StatefulWidget {

  final Hangout hangout;

  EditHangout(this.hangout);

  @override
  State<StatefulWidget> createState() {

    return _EditHangoutState();
  }
}


class _EditHangoutState extends State<EditHangout> {

  String _title = '';
  String _description = '';
  String _location = '';
  int _attendeeLimit = 0;
  DateTime _dateTime = DateTime.now();


  @override
  initState() {
    super.initState();
    _title = widget.hangout.title;
    _description = widget.hangout.description;
    _location = widget.hangout.location;
    _attendeeLimit = widget.hangout.attendeeLimit;
    _dateTime = widget.hangout.datetime;
  }


  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.hangout.title}"),
        backgroundColor: Colors.teal[200],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: "Log out",
            color: Colors.white,
            onPressed: () {
              userBloc.logoutUser(context);
            },
          ),
        ],
      ),

      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
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
            Validation(),
            PageBreak(10.0),
            _submit(userBloc, context),
            PageBreak(10.0),
            Divider(),
            PageBreak(10.0),
            TitleText("Invited Members"),
            PageBreak(10.0),
            ..._invitedList(userBloc),
          ],
        ),
      ),
    );
  }


  Widget _submit(UserBloc userBloc, BuildContext context) {
    return RaisedButton(
      child: Text('Submit'),
      textColor: Colors.white,
      color: Colors.teal[200],
      onPressed: () {
        userBloc.updateHangout(widget.hangout.id, _title, _description, _location, _attendeeLimit, _dateTime);
        Navigator.pop(context);
      },
    );
  }


  List<Widget> _invitedList(UserBloc userBloc) {

    return widget.hangout.invited.map(
      (user) {
        return UserListItem(
          user,
          noPadding: true,
          actionButton: (userBloc) => IconButton(
            icon: Icon(Icons.delete),
            iconSize: 30.0,
            color: Colors.teal[400],
            onPressed: () {
              userBloc.uninviteUser(user, widget.hangout);
              widget.hangout.removeInvited(user);
            },
          ),
        );
      }
    ).toList();
  }
}