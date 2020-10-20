import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../widgets/menu.dart';
import './profile.dart';
import './search.dart';
import './add.dart';
import './hangouts.dart';
import './groups.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Let's Hang"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: "Log out",
            onPressed: () {
              userBloc.logoutUser(context);
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        child: _screen(userBloc),
        onRefresh: () async {
          return userBloc.fetchCurrentUser();
        }
      ),

      bottomNavigationBar: Menu(),
    );
  }


  Widget _screen(UserBloc userBloc) {

    switch (userBloc.menuIndex) {
      case 0:
        return Hangouts();
      case 1:
        return Search();
      case 2:
        return Add(userBloc.currentUser.friends.id);
      case 3:
        return Groups();
      case 4:
        return Profile();
    }

    return Text('You shouldn\'t be here. This text is just to appease my code editor.');
  }
}