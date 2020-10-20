import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/hangout.dart';
import '../models/error.dart';

String _api = 'https://lets-hang-api.herokuapp.com/graph';

class Repository {

  Client client = Client();

  ///
  /// Query the API using the [query] with the [token]
  /// in the header JWT for authentication.
  /// Return the object with the key [dataObject]
  ///
  Future _sendQuery(String token, String query, String dataObject) async {

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    if (token != null) {
      headers['token'] = token;
    }

    String body = json.encode({ "query": query });

    final response = await client.post(_api, headers: headers, body: body);
    final jsonResponse = json.decode(response.body);

    if (jsonResponse['data'] != null) {
      return jsonResponse['data'][dataObject];
    } else {
      return jsonResponse;
    }
  }


  ///
  /// Check to see if a user with the provided [email] exists
  ///
  /// Return Future<bool> | Future<Error>
  ///
  Future checkEmail(String email) async {

    String query = """
      {
        checkEmail(email: "$email")
      }
    """;

    // Send the query and return the response
    final response = await _sendQuery(null, query, 'checkEmail');
    if (response is Map && response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    }
    return response;
  }


  ///
  /// Create a user using a provided
  /// [email], [password], [firstName], and [lastName].
  /// If we got a successful response, save the response token to localstorage
  ///
  /// Return Future<Error> | Future<User>
  ///
  Future createUser(
    String email,
    String password,
    String firstName,
    String lastName
  ) async {

    // Format how the arguments are passed
    email = email != null ? '"$email"' : "null";
    password = password != null ? '"$password"' : "null";
    firstName = firstName != null ? '"$firstName"' : "null";
    lastName = lastName != null ? '"$lastName"' : "null";

    // Form the query
    String query = """
      mutation {
        createUser(
          email: $email,
          password: $password,
          firstName: $firstName,
          lastName: $lastName
        ) {
          token
        }
      }
    """;

    // Send the query
    final response = await _sendQuery(null, query, 'createUser');

    // Handle an error response
    if (response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    }

    // Save the token to localstorage
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('token', response['token']);

    // Fetch the created user and return it
    return await fetchCurrentUser(response['token']);
  }


  ///
  /// Login a user using a provided [email] and [password].
  /// If we got a successful response, save the response token to localstorage
  ///
  /// Return Future<Error> | Future<User>
  ///
  Future loginUser(String email, String password) async {

    // Form the query
    String query = """
      mutation {
        loginUser(
          email: "$email",
          password: "$password"
        ) {
          token
        }
      }
    """;

    // Send the query
    final response = await _sendQuery(null, query, 'loginUser');

    if (response == null) {
      return null;
    }

    // Handle an error response
    if (response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    }

    // Save the token to localstorage
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('token', response['token']);

    // Fetch the authenticated user
    return await fetchCurrentUser(response['token']);
  }


  ///
  /// Fetch a user's token from localstorage.
  ///
  /// Return Future<String> | null
  ///
  Future fetchToken() async {

    try {
      // Get token from local storage
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String token = localStorage.getString('token');

      return token;
    } catch (exception) {
      SharedPreferences.setMockInitialValues({});
      return null;
    }
  }


  ///
  /// Fetch the current user from the api using a [token]
  ///
  /// Return Future<User> | Future<Error>
  ///
  Future fetchCurrentUser(String token) async {

    String query = """
      {
        currentUser {
          _id
          email
          firstName
          lastName
          groups {
            _id
            title
            description
            owner {
              _id
              email
              firstName
              lastName
            }
            members {
              _id
              email
              firstName
              lastName
              groups {
                _id
                title
                members {
                  _id
                }
              }
            }
          }
          memberOf {
            _id
            title
            description
            owner {
              _id
              email
              firstName
              lastName
            }
            members {
              _id
              email
              firstName
              lastName
            }
          }
          hangouts {
            _id
            title
            description
            location
            attendeeLimit
            datetime
            organizer {
              _id
              email
              firstName
              lastName
            }
            invited {
              _id
              email
              firstName
              lastName
            }
            attendees {
              _id
              email
              firstName
              lastName
            }
          }
          attending {
            _id
            title
            description
            location
            attendeeLimit
            datetime
            organizer {
              _id
              email
              firstName
              lastName
            }
            invited {
              _id
              email
              firstName
              lastName
            }
            attendees {
              _id
              email
              firstName
              lastName
            }
          }
          invitedTo {
            _id
            title
            description
            location
            attendeeLimit
            datetime
            organizer {
              _id
              email
              firstName
              lastName
            }
            invited {
              _id
              email
              firstName
              lastName
            }
            attendees {
              _id
              email
              firstName
              lastName
            }
          }
        }
      }
    """;

    final response = await _sendQuery(token, query, 'currentUser');

    if (response == null) {
      return User();
    }

    // Handle an error response
    if (response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    }

    return User.fromMap(response);
  }


  ///
  /// Remove the token from localstorage
  ///
  void logoutUser() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
  }


  ///
  /// Create a hangout
  /// If we got a successful response,
  ///
  /// Return Future<Error> | Future<Hangout>
  ///
  Future createHangout(
    String title,
    String description,
    String location,
    int attendeeLimit,
    DateTime dateTime
  ) async {

    // Format how the arguments are passed
    title = title != '' ? '"$title"' : "null";
    description = description != '' ? '"$description"' : "null";
    location = location != '' ? '"$location"' : "null";
    String limit = attendeeLimit != null ? '${attendeeLimit.toString()}' : "null";

    String dateString = DateTime(dateTime.year, dateTime.month, dateTime.minute, dateTime.hour, dateTime.second).toString();
    String datetime = '"${dateString.replaceAll(' ', 'T')}Z"';

    // Form the query
    String query = """
      mutation {
        createHangout(
          title: $title,
          description: $description,
          location: $location,
          datetime: $datetime,
          attendeeLimit: $limit
        ) {
          _id
          title
          description
          location
          datetime
          attendeeLimit
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    final response = await _sendQuery(token, query, 'createHangout');

    if (response == null) {
      return null;
    }

    // Handle an error response
    if (response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    }

    // Return the hangout
    return Hangout.fromMap(response);
  }


  ///
  ///
  ///
  Future updateHangout(
    String id,
    String title,
    String description,
    String location,
    int attendeeLimit,
    DateTime dateTime
  ) async {

    // Format how the arguments are passed
    title = title != '' ? '"$title"' : "null";
    description = description != '' ? '"$description"' : "null";
    location = location != '' ? '"$location"' : "null";
    String limit = attendeeLimit != null ? '${attendeeLimit.toString()}' : "0";

    String dateString = DateTime(dateTime.year, dateTime.month, dateTime.minute, dateTime.hour, dateTime.second).toString();
    String datetime = '"${dateString.replaceAll(' ', 'T')}Z"';

    // Form the query
    String query = """
      mutation {
        updateHangout(
          hangoutId: "$id",
          title: $title,
          description: $description,
          location: $location,
          datetime: $datetime,
          attendeeLimit: $limit
        ) {
          _id
          title
          description
          location
          attendeeLimit
          datetime
          organizer {
            _id
            email
            firstName
            lastName
          }
          invited {
            _id
            email
            firstName
            lastName
          }
          attendees {
            _id
            email
            firstName
            lastName
          }
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    final response = await _sendQuery(token, query, 'updateHangout');

    if (response == null) {
      return null;
    }

    // Handle an error response
    if (response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    }

    // Return the hangout
    return Hangout.fromMap(response);

  }


  ///
  /// 
  ///
  Future deleteHangout(String hangoutId) async {

    // Form the query
    String query = """
      mutation {
        deleteHangout(hangoutId: "$hangoutId") {
          _id
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    final response = await _sendQuery(token, query, 'deleteHangout');

    if (response == null) {
      return null;
    }

    // Handle an error response
    if (response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    } else {
      return true;
    }
  }


  ///
  /// 
  ///
  Future inviteUser(String hangoutId, String userId) async {

    // Form the query
    String query = """
      mutation {
        inviteUser(
          hangoutId: "$hangoutId",
          userId: "$userId"
        ) {
          _id
          invited {
            _id
          }
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    final response = await _sendQuery(token, query, 'inviteUser');

    if (response == null) {
      return null;
    }

    // Handle an error response
    if (response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    } else {
      return true;
    }
  }


  ///
  /// 
  ///
  Future joinHangout(String hangoutId) async {

    // Form the query
    String query = """
      mutation {
        joinHangout(hangoutId: "$hangoutId") {
          _id
          attendees {
            _id
          }
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    final response = await _sendQuery(token, query, 'joinHangout');

    if (response == null) {
      return null;
    }

    // Handle an error response
    if (response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    } else {
      return true;
    }
  }


  ///
  /// 
  ///
  Future leaveHangout(String hangoutId) async {

    // Form the query
    String query = """
      mutation {
        leaveHangout(hangoutId: "$hangoutId") {
          _id
          attendees {
            _id
          }
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    final response = await _sendQuery(token, query, 'leaveHangout');

    if (response == null) {
      return null;
    }

    // Handle an error response
    if (response['errors'] != null) {
      return Error.fromResponse(response['errors']);
    } else {
      return true;
    }
  }


  ///
  /// 
  ///
  Future uninviteUser(String userId, String hangoutId) async {

    // Build the query
    String query = """
      mutation {
        uninviteUser(userId: "$userId", hangoutId: "$hangoutId") {
          _id
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    await _sendQuery(token, query, 'uninviteUser');
  }


  ///
  /// 
  ///
  Future searchUsers(String search) async {

    String query = """
      {
        users(search: "$search") {
          _id
          email
          firstName
          lastName
          groups {
            title
            members {
              _id
            }
          }
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    final response = await _sendQuery(token, query, 'users');

    return response.map((user) {
      return User.fromMap(user);
    }).toList();
  }


  ///
  /// 
  ///
  void addToGroup(String userId, String groupId) async {

    // Build the query
    String query = """
      mutation {
        addToGroup(userId: "$userId", groupId: "$groupId") {
          _id
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    await _sendQuery(token, query, 'addToGroup');
  }


  ///
  /// 
  ///
  void removeFromGroup(String userId, String groupId) async {

    // Build the query
    String query = """
      mutation {
        removeFromGroup(userId: "$userId", groupId: "$groupId") {
          _id
        }
      }
    """;

    String token = await fetchToken();

    // Send the query
    await _sendQuery(token, query, 'removeFromGroup');
  }
}