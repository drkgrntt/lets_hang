import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';


class Menu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[

        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          title: Text('Hangouts'),
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Search'),
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          title: Text('Add'),
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          title: Text('Groups'),
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.portrait),
          title: Text('Profile'),
        ),

      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: userBloc.menuIndex,
      onTap: (index) {
        userBloc.menuIndex = index;
      },
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.white54,
      selectedItemColor: Colors.white,
    );
  }
}