import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../widgets/userListItem.dart';
import '../widgets/pageBreak.dart';


class Search extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}


class _SearchState extends State<Search> {

  TextEditingController _controller = TextEditingController();
  Timer _timer;
  List _users = [];

  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: TextField(
            onChanged: (value) {
              _controller.text = value;
              if (_timer != null && _timer.isActive) {
                _timer.cancel();
                _timer = null;
              }
              _timer = Timer(Duration(seconds: 1), () async {
                _users = await userBloc.searchUsers(_controller.text);
              });
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Search users',
            ),
          ),
        ),
        PageBreak(8.0),
        ..._userList(),
      ],
    );
  }


  List<Widget> _userList() {

    return _users.map((user) {
      return UserListItem(user);
    }).toList();
  }
}