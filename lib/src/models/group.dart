import './user.dart';

class Group {

  String id;
  String title;
  String description;
  User owner;
  List members = [];


  Group();


  Group.fromMap(Map groupData) {
    if (groupData != null) {

      id = groupData['_id'];
      title = groupData['title'];
      description = groupData['description'];
      owner = User.fromMap(groupData['owner']);

      if (groupData['members'] != null) {
        members = groupData['members'].map((user) => User.fromMap(user)).toList();
      }
    }
  }


  String toString() => "Group => $id : $title : ${owner.email}";


  bool isFriends() {
    return title == 'Friends';
  }


  bool includes(User user) {
    for (User member in members) {
      if (user.id == member.id) {
        return true;
      }
    }
    return false;
  }


  void removeFromGroup(User user) {
    for (User member in members) {
      if (member.id == user.id) {
        members.remove(member);
        break;
      }
    }
  }
}