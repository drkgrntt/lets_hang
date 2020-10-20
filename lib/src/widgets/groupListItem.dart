import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/userBloc.dart';
import '../models/group.dart';
import '../models/user.dart';
import './plainText.dart';
import './titleText.dart';
import './pageBreak.dart';
import './userListItem.dart';


class GroupListItem extends StatefulWidget {

  final Group group;
  final bool selected;


  GroupListItem({ this.selected, this.group });


  @override
  State<StatefulWidget> createState() {
    return _GroupListItemState();
  }
}


class _GroupListItemState extends State<GroupListItem> {

  String _selectedUser = '';

  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = Provider.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              TitleText(widget.group.title),
              Spacer(),
            ],
          ),
          PageBreak(5.0),
          PlainText(widget.group.description),
          ..._membersList(userBloc),
        ],
      ),
    );
  }


  List<Widget> _membersList(UserBloc userBloc) {

    if (widget.selected && widget.group.members.length > 0) {

      return <Widget>[
        PageBreak(10.0),
        ...widget.group.members.map(
          (member) {
            return GestureDetector(
              onTap: () {
                setState(() => _selectedUser = member.id);
              },
              child: UserListItem(
                member,
                selected: member.id == _selectedUser,
                // noPadding: true,
                actionButton: (UserBloc userBloc) => Container(),
                expanded: () {
                  return _memberExpanded(member, userBloc);
                },
              ),
            );
          }
        ).toList(),
      ];

    } else {

      return [
        PageBreak(5.0),
        PlainText('${widget.group.members.length.toString()} members'),
        Divider()
      ];
    }
  }


  Widget _memberExpanded(User member, UserBloc userBloc) {

    return Row(
      children: <Widget>[
        RaisedButton(
          child: Text('Invite'),
          onPressed: () {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text('Which hangout would you like to invite ${member.firstName} to?'),
                  children: <Widget>[
                    ...userBloc.currentUser.hangouts.map(
                      (hangout) {
                        if (!member.isInvitedTo(hangout)) {
                          return SimpleDialogOption(
                            child: PlainText(hangout.title),
                            onPressed: () {
                              userBloc.inviteUser(member, hangout);
                              Navigator.pop(context);
                            }
                          );
                        }
                      }
                    ).toList(),
                  ],
                );
              }
            );
          },
        ),
        Spacer(),
        RaisedButton(
          child: Text('Remove'),
          color: Theme.of(context).errorColor,
          onPressed: () {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text('Are you sure you want to remove ${member.fullName} from ${widget.group.isFriends() ? 'all groups' : widget.group.title}?'),
                  children: <Widget>[
                    SimpleDialogOption(
                      child: PlainText('Yes'),
                      onPressed: () {
                        userBloc.removeFromGroup(member, widget.group);
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
    );
  }
}