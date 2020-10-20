import 'package:flutter/material.dart';
import '../blocs/userBloc.dart';
import '../models/hangout.dart';
import '../resources/utility.dart';
import './plainText.dart';
import './bullet.dart';
import './titleText.dart';
import './pageBreak.dart';
import './validation.dart';


class HangoutListItem extends StatelessWidget {

  final UserBloc userBloc;
  final Hangout hangout;
  final bool selected;


  HangoutListItem({ this.selected, this.hangout, this.userBloc });


  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              TitleText(hangout.title),
              Spacer(),
              PlainText(Utility.formatDateTime(hangout.datetime)),
            ],
          ),
          _organizer(),
          ..._additionalInfo(context),
          Divider(),
        ],
      ),
    );
  }


  Widget _organizer() {
    if (userBloc.currentUser.id != hangout.organizer.id) {
      return PlainText('with ${hangout.organizer.fullName}');
    }

    return Container();
  }


  List<Widget> _additionalInfo(BuildContext context) {

    if (selected) {
      return <Widget>[
        ..._buttonOptions(context),
        PlainText('Description', underlined: true),
        PlainText(hangout.description),
        PageBreak(10.0),
        PlainText('Location', underlined: true),
        PlainText(hangout.location),
        PageBreak(10.0),
        ..._limit(),
        ..._attending(),
        ..._invited(),
      ];
    } else {
      return [];
    }
  }


  List<Widget> _buttonOptions(BuildContext context) {

    if (userBloc.currentUser.id == hangout.organizer.id) {
      return _editButtons(context);
    } else {
      return _hangoutButton();
    }
  }


  List<Widget> _hangoutButton() {

    bool isAttending = userBloc.currentUser.isAttending(hangout);

    return [
      Row(
        children: <Widget>[
          PlainText('You will ${!isAttending ? "not " : ""}be there.'),
          Spacer(),
          RaisedButton(
            child: Text('${isAttending ? "Leave" : "Join"}'),
            onPressed: () => isAttending
              ? userBloc.leaveHangout(hangout)
              : userBloc.joinHangout(hangout)
          ),
        ],
      ),
      Validation(),
    ];
  }


  List<Widget> _editButtons(BuildContext context) {
    return [
      PlainText('Organizer Options', underlined: true),
      Row(
        children: <Widget>[
          RaisedButton(
            child: Text('Edit'),
            color: Theme.of(context).accentColor,
            onPressed: () => Navigator.pushNamed(context, '/hangout/${hangout.id}'),
          ),
          Spacer(),
          RaisedButton(
            child: Text('Delete'),
            color: Theme.of(context).errorColor,
            onPressed: () {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Are you sure you want to delete ${hangout.title}?'),
                    children: <Widget>[
                      SimpleDialogOption(
                        child: PlainText('Yes'),
                        onPressed: () {
                          userBloc.deleteHangout(hangout);
                          Navigator.pop(context);
                        },
                      ),
                      SimpleDialogOption(
                        child: PlainText('No'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      PageBreak(10.0),
    ];
  }


  List<Widget> _limit() {

    if (
      userBloc.currentUser.id == hangout.organizer.id &&
      hangout.attendeeLimit != 0
    ) {
      return [
        PlainText('${hangout.attendeeLimit - hangout.attendees.length} can still join.'),
        PageBreak(10.0),
      ];
    } else {
      return [];
    }
  }


  List<Widget> _attending() {
    
    if (hangout.attendees.length > 0) {
      return <Widget>[
        PlainText("Attending (${hangout.attendees.length})", underlined: true),
        ...hangout.attendees.map(
          (attendee) {
            String name = userBloc.currentUser.id == attendee.id ? 'You' : attendee.fullName;

            return Row(
              children: <Widget>[
                Bullet(),
                PlainText(name),
              ],
            );
          },
        ).toList(),
      ];
    } else {
      return [PlainText('No one attending yet.')];
    }
  }


  List<Widget> _invited() {
    if (userBloc.currentUser.id == hangout.organizer.id) {
      if (hangout.invited.length > 0) {
        return <Widget>[
          PageBreak(10.0),
          PlainText("Invited (${hangout.invited.length})", underlined: true),
          ...hangout.invited.map(
            (invited) {
              String name = userBloc.currentUser.id == invited.id ? 'You' : invited.fullName;

              return Row(
                children: <Widget>[
                  Bullet(),
                  PlainText(name),
                ],
              );
            },
          ).toList(),
        ];
      } else {
        return [PlainText('No one invited yet.')];
      }
    } else {
      return [];
    }
  }
}