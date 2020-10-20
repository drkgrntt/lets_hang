import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../widgets/groupListItem.dart';
import '../widgets/pageBreak.dart';
import '../widgets/plainText.dart';


class Groups extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _GroupsState();
  }
}


class _GroupsState extends State<Groups> {

  String _selectedGroup = '';
  int _subMenuIndex = 0;


  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return ListView(
      children: <Widget>[
        _subMenu(),
        PageBreak(10.0),
        ..._groupsContent(userBloc),
      ],
    );
  }


  Widget _subMenu() {

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
                child: PlainText('Groups', inverted: _subMenuIndex == 0),
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
                child: PlainText('Create', inverted: _subMenuIndex == 1),
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


  List<Widget> _groupsContent(UserBloc userBloc) {

    if (_subMenuIndex == 0) {
      return userBloc.currentUser.groups.map(
        (group) {
          if (group.title == 'Friends') {
            group = userBloc.currentUser.friends;
          }
          return GestureDetector(
            onTap: () => setState(() => _selectedGroup = group.id),
            child: GroupListItem(
              group: group,
              selected: _selectedGroup == group.id
            ),
          );
        }
      ).toList();
    } else {
      return [PlainText('Create')];
    }
  }
}