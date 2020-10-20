import './user.dart';

class Hangout {

  String id;
  String title;
  String description;
  String location;
  DateTime datetime;
  int attendeeLimit;
  User organizer;
  List invited = [];
  List attendees = [];


  Hangout();


  Hangout.fromMap(Map hangoutData) {

    if (hangoutData != null) {

      id = hangoutData['_id'];
      title = hangoutData['title'];
      description = hangoutData['description'];
      location = hangoutData['location'];
      datetime = DateTime.parse(hangoutData['datetime']);
      attendeeLimit = hangoutData['attendeeLimit'];
      organizer = User.fromMap(hangoutData['organizer']);

      if (hangoutData['invited'] != null) {
        invited = hangoutData['invited'].map((user) => User.fromMap(user)).toList();
      }
      if (hangoutData['attendees'] != null) {
        attendees = hangoutData['attendees'].map((user) => User.fromMap(user)).toList();
      }
    }
  }

  String toString() => "Hangout => $id : $title : ${organizer.email}";


  void removeAttendee(User removingUser) {
    for (User user in attendees) {
      if (user.id == removingUser.id) {
        attendees.remove(user);
        break;
      }
    }
  }


  void removeInvited(User removingUser) {
    for (User user in invited) {
      if (user.id == removingUser.id) {
        invited.remove(user);
        break;
      }
    }
  }
}