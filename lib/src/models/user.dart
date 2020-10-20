import './hangout.dart';
import './group.dart';

class User {

  String id;
  String email;
  String firstName;
  String lastName;
  String fullName;
  List groups = [];
  List memberOf = [];
  List hangouts = [];
  List invitedTo = [];
  List attending = [];
  Group friends;


  User();


  User.fromMap(Map userData) {
    if (userData != null) {

      id = userData['_id'];
      email = userData['email'];
      firstName = userData['firstName'];
      lastName = userData['lastName'];
      fullName = "$firstName $lastName";

      if (userData['groups'] != null) {
        groups = userData['groups'].map((group) {
          Group newGroup = Group.fromMap(group);
          if (newGroup.title == 'Friends') {
            friends = newGroup;
          }
          return newGroup;
        }).toList();
      }
      if (userData['memberOf'] != null) {
        memberOf = userData['memberOf'].map((group) => Group.fromMap(group)).toList();
      }
      if (userData['hangouts'] != null) {
        hangouts = userData['hangouts'].map((hangout) => Hangout.fromMap(hangout)).toList();
      }
      if (userData['invitedTo'] != null) {
        invitedTo = userData['invitedTo'].map((hangout) => Hangout.fromMap(hangout)).toList();
      }
      if (userData['attending'] != null) {
        attending = userData['attending'].map((hangout) => Hangout.fromMap(hangout)).toList();
      }
    }
  }

  String toString() => "User => $id : $email : $fullName";


  bool isFriendsWith(User user) {
    for (User friend in friends.members) {
      if (friend.id == user.id) {
        return true;
      }
    }
    return false;
  }


  bool isMutualFriendsWith(User user) {
    if (this.isFriendsWith(user) && user.isFriendsWith(this)) {
      return true;
    }
    return false;
  }


  bool isInvitedTo(Hangout hangoutInQuestion) {
    for (Hangout hangout in invitedTo) {
      if (hangout.id == hangoutInQuestion.id) {
        return true;
      }
    }
    return false;
  }


  bool isAttending(Hangout hangoutInQuestion) {
    for (Hangout hangout in attending) {
      if (hangout.id == hangoutInQuestion.id) {
        return true;
      }
    }
    return false;
  }


  void leaveHangout(Hangout hangoutInQuestion) {
    for (Hangout hangout in attending) {
      if (hangout.id == hangoutInQuestion.id) {
        attending.remove(hangout);
        break;
      }
    }
  }


  void deleteHangout(Hangout hangoutInQuestion) {
    for (Hangout hangout in hangouts) {
      if (hangout.id == hangoutInQuestion.id) {
        hangouts.remove(hangout);
        break;
      }
    }
  }
}