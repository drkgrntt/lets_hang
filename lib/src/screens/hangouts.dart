import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../widgets/hangoutListItem.dart';
import '../widgets/pageBreak.dart';
import '../widgets/plainText.dart';


class Hangouts extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HangoutsState();
  }
}


class _HangoutsState extends State<Hangouts> {

  String _selectedHangout = '';
  int _subMenuIndex = 0;


  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return ListView(
      children: <Widget>[
        _subMenu(context),
        PageBreak(10.0),
        ..._hangouts(userBloc),
      ],
    );
  }


  Widget _subMenu(BuildContext context) {

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () => setState(() => _subMenuIndex = 0),
            child: Container(
              color: _subMenuColor(context, 0),
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: PlainText('Invited', inverted: _subMenuIndex == 0),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () => setState(() => _subMenuIndex = 1),
            child: Container(
              color: _subMenuColor(context, 1),
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: PlainText('Attending', inverted: _subMenuIndex == 1),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () => setState(() => _subMenuIndex = 2),
            child: Container(
              color: _subMenuColor(context, 2),
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: PlainText('Mine', inverted: _subMenuIndex == 2),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Color _subMenuColor(BuildContext context, int index) => _subMenuIndex == index
    ? Theme.of(context).primaryColor
    : Theme.of(context).primaryColorLight;


  List<Widget> _hangouts(UserBloc userBloc) {

    switch (_subMenuIndex) {
      case 0:
        return userBloc.currentUser.invitedTo.map(
          (hangout) => _hangoutList(userBloc, hangout)
        ).toList();
      case 1:
        return userBloc.currentUser.attending.map(
          (hangout) => _hangoutList(userBloc, hangout)
        ).toList();
      default:
        return userBloc.currentUser.hangouts.map(
          (hangout) => _hangoutList(userBloc, hangout)
        ).toList();
    }
  }


  Widget _hangoutList(userBloc, hangout) {

    bool selected = _selectedHangout == hangout.id;
    return GestureDetector(
      onTap: () => setState(() {
        userBloc.resetTextFields();
        _selectedHangout = hangout.id;
      }),
      child: HangoutListItem(userBloc: userBloc, hangout: hangout, selected: selected),
    );
  }
}