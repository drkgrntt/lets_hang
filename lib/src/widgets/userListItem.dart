import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../models/user.dart';
import './titleText.dart';
import './plainText.dart';


class UserListItem extends StatelessWidget {

  final User user;
  final bool selected;
  final bool noPadding;
  final Function expanded;
  final Function actionButton;


  UserListItem(this.user, { this.selected = false, this.noPadding = false, this.expanded, this.actionButton });


  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    double padding = noPadding ? 0.0 : 15.0;

    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TitleText(user.fullName),
                  PlainText(user.email),
                ],
              ),
              Spacer(),
              _actionButton(context, userBloc),
            ],
          ),
          _expanded(userBloc, context),
          Divider(),
        ],
      ),
    );
  }


  Widget _actionButton(BuildContext context, UserBloc userBloc) {

    // If an action button was provided, use it
    if (actionButton != null) {
      return actionButton(userBloc);
    }

    if (userBloc.currentUser.id == user.id) {

      return Padding(
        padding: EdgeInsets.only(right: 9.0),
        child: Icon(
          Icons.star_border,
          size: 30.0,
          color: Theme.of(context).primaryColor,
        ),
      );

    } else if (userBloc.currentUser.isMutualFriendsWith(user)) {

      return IconButton(
        icon: Icon(Icons.favorite_border),
        iconSize: 30.0,
        color: Theme.of(context).primaryColor,
        onPressed: () => userBloc.removeFriend(user),
      );

    } else if (userBloc.currentUser.isFriendsWith(user)) {

      return IconButton(
        icon: Icon(Icons.check),
        iconSize: 30.0,
        color: Theme.of(context).primaryColor,
        onPressed: () => userBloc.removeFriend(user),
      );

    } else {

      return IconButton(
        icon: Icon(Icons.add),
        iconSize: 30.0,
        color: Theme.of(context).primaryColor,
        onPressed: () => userBloc.addFriend(user),
      );
    }
  }


  Widget _expanded(UserBloc userBloc, BuildContext context) {

    if (expanded != null && selected) {
      return expanded();
    }
    return Container();
  }
}
