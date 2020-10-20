import 'package:flutter/material.dart';
import '../resources/repository.dart';
import '../models/user.dart';
import '../models/group.dart';
import '../models/hangout.dart';
import '../models/error.dart';


class UserBloc extends ChangeNotifier {

  final _repository = Repository();

  // State vars
  int _menuIndex = 0;
  List<String> _screenTitles = ['Feed', 'Search', 'Add', 'Hangouts', 'Groups'];
  User _currentUser;
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  String _validationMessage = '';

  // Getters
  int get menuIndex => _menuIndex;
  String get screenTitle => _screenTitles[_menuIndex];
  User get currentUser => _currentUser;
  String get email => _email;
  String get password => _password;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get validationMessage => _validationMessage;

  // Setters
  set menuIndex(int value) {
    _menuIndex = value;
    notifyListeners();
  }
  set currentUser(User value) {
    _currentUser = value;
    notifyListeners();
  }
  set email(String value) {
    _email = value;
    notifyListeners();
  }
  set password(String value) {
    _password = value;
    notifyListeners();
  }
  set firstName(String value) {
    _firstName = value;
    notifyListeners();
  }
  set lastName(String value) {
    _lastName = value;
    notifyListeners();
  }
  set validationMessage(String value) {
    _validationMessage = value;
    notifyListeners();
  }


  ///
  /// Check localstorage for a user token,
  /// authenticate with the token, and then
  /// add the recieved user to the sink
  ///
  /// If response is an Error, do not add it.
  ///
  void fetchCurrentUser() async {
    final storedToken = await _repository.fetchToken();

    // Get user by token
    final response = await _repository.fetchCurrentUser(storedToken);

    if (response is User) {
      currentUser = response;
    }
  }


  ///
  /// Check to see if a particular email address
  /// already exists in the database
  /// Then navigate with [context] based on whether or not it exists
  ///
  void checkEmail(BuildContext context) async {
    final userExists = await _repository.checkEmail(email);

    if (userExists is Error) {
      validationMessage = userExists.message;
    }

    validationMessage = '';
    if (userExists) {
      Navigator.pushNamed(context, '/login');
    } else if (!userExists) {
      Navigator.pushNamed(context, '/register');
    }
  }


  ///
  /// Use email and password to get a token from the api
  /// Then navigate with [context]
  ///
  void loginUser(BuildContext context) async {
    validationMessage = 'Logging you in.';

    final response = await _repository.loginUser(email, password);

    if (response is User) {
      resetTextFields();
      fetchCurrentUser();
      Navigator.pushNamed(context, '/home');
    } else {
      validationMessage = response.message;
    }
  }


  ///
  /// Create a user with an email, password, first name, and last name
  /// Then navigate with [context]
  ///
  void createUser(BuildContext context) async {
    validationMessage = 'Building your account.';

    final response = await _repository.createUser(email, password, firstName, lastName);

    if (response is User) {
      resetTextFields();
      fetchCurrentUser();
      Navigator.pushNamed(context, '/home');
    } else {
      validationMessage = response.message;
    }
  }


  ///
  /// Reset all text fields after logging in
  ///
  void resetTextFields() {
    email = '';
    password = '';
    firstName = '';
    lastName = '';
    validationMessage = '';
  }


  ///
  /// Discard the token from localstorage
  ///
  void logoutUser(BuildContext context) {
    _repository.logoutUser();
    currentUser = null;
    Navigator.pushNamed(context, '/');
  }


  ///
  /// Submit [title], [description], [location], [attendeeLimit], and
  /// [dateTime] to create a new hangout. Then add all users who are in
  /// the [invited] groups to the hangout.
  ///
  void createHangout(
    String title,
    String description,
    String location,
    int attendeeLimit,
    DateTime dateTime,
    List<String> invited
  ) async {
    validationMessage = 'Creating hangout...';

    // Create the hangout
    final hangout = await _repository.createHangout(title, description, location, attendeeLimit, dateTime);

    if (hangout is Error) {
      validationMessage = hangout.message;
    } else {

      hangout.organizer = currentUser;

      // Invite users
      for (Group group in currentUser.groups) {
        if (invited.indexOf(group.id) != -1) {
          for (User user in group.members) {
            await _repository.inviteUser(hangout.id, user.id);
          }
          hangout.invited = group.members;
        }
      }

      // Add the hangout to the current user
      currentUser.hangouts.add(hangout);

      validationMessage = '';

      // Show the user's list of hangouts
      menuIndex = 0;
    }
  }


  ///
  /// Submit [title], [description], [location], [attendeeLimit], and
  /// [dateTime] to update a hangout by [id] hangout.
  ///
  void updateHangout(
    String id,
    String title,
    String description,
    String location,
    int attendeeLimit,
    DateTime dateTime,
  ) async {
    validationMessage = 'Updating hangout...';

    // update the hangout
    final updatedHangout = await _repository.updateHangout(id, title, description, location, attendeeLimit, dateTime);

    if (updatedHangout is Error) {
      validationMessage = updatedHangout.message;
    } else {

      User newCurrentUser = currentUser;
      newCurrentUser.hangouts = newCurrentUser.hangouts.map((hangout) {
        if (updatedHangout.id == hangout.id) {
          return updatedHangout;
        } else {
          return hangout;
        }
      }).toList();

      currentUser = newCurrentUser;
      resetTextFields();
    }
  }


  ///
  /// Delete a particular [hangout]
  ///
  void deleteHangout(Hangout hangout) {

    _repository.deleteHangout(hangout.id);

    User newCurrentUser = currentUser;
    newCurrentUser.deleteHangout(hangout);
    currentUser = newCurrentUser;
  }


  ///
  /// Query the database for all emails like the [search] string
  ///
  Future searchUsers(String search) async {
    return await _repository.searchUsers(search);
  }


  ///
  /// Add a particular [user] to the current user's friends group
  ///
  void addFriend(User user) {

    User newCurrentUser = currentUser;
    _repository.addToGroup(user.id, currentUser.friends.id);

    newCurrentUser.friends.members.add(user);
    currentUser = newCurrentUser;
  }


  ///
  /// Remove a particular [user] from all of the current user's groups
  ///
  void removeFriend(User user) {

    currentUser.groups.forEach((group) {
      removeFromGroup(user, group);
    });
  }


  ///
  /// Remove a particular [user] from a particular [group]
  ///
  void removeFromGroup(User user, Group group) {

    _repository.removeFromGroup(user.id, group.id);

    User newCurrentUser = currentUser;
    newCurrentUser.groups = newCurrentUser.groups.map(
      (newGroup) {
        if (newGroup.id == group.id) {
          group.removeFromGroup(user);
          return group;
        }
        return newGroup;
      }
    ).toList();
    currentUser = newCurrentUser;
  }


  ///
  /// Join a particular [hangout]
  ///
  void joinHangout(Hangout hangout) {
    if (
      hangout.attendeeLimit == 0 ||
      hangout.attendees.length < hangout.attendeeLimit
    ) {
      hangout.attendees.add(currentUser);
      _repository.joinHangout(hangout.id);
      User newCurrentUser = currentUser;
      newCurrentUser.attending.add(hangout);
      currentUser = newCurrentUser;
    } else {
      validationMessage = 'Sorry, this hangout is full';
    }
  }


  ///
  /// Leave a particular [hangout]
  ///
  void leaveHangout(Hangout hangout) {
    _repository.leaveHangout(hangout.id);
    User newCurrentUser = currentUser;
    newCurrentUser.leaveHangout(hangout);
    hangout.removeAttendee(currentUser);
    currentUser = newCurrentUser;
  }


  ///
  /// Invite a particular [user] to a particular [hangout]
  ///
  void inviteUser(User user, Hangout hangout) {

    _repository.inviteUser(hangout.id, user.id);

    User newCurrentUser = currentUser;
    newCurrentUser.hangouts = newCurrentUser.hangouts.map(
      (newHangout) {
        if (newHangout.id == hangout.id) {
          newHangout.invited.add(user);
        }
        return newHangout;
      }
    ).toList();
  }


  ///
  /// Remove a particular [user] from the invited list for a particular [hangout]
  ///
  void uninviteUser(User user, Hangout hangout) {

    // Hit the API
    _repository.uninviteUser(user.id, hangout.id);

    // Remove the user from invited
    hangout.removeInvited(user);

    // Remove user from attendees if necessary
    hangout.removeAttendee(user);

    User newCurrentUser = currentUser;
    newCurrentUser.hangouts = newCurrentUser.hangouts.map(
      (newHangout) {
        if (newHangout.id == hangout.id) {
          return hangout;
        }
        return newHangout;
      }
    ).toList();
    currentUser = newCurrentUser;
  }
}
