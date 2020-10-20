class Error {

  String message = '';
  String path = '';
  String code = '';


  Error();


  Error.fromResponse(List errorData) {

    path = errorData[0]['path'] != null ? errorData[0]['path'][0] : null;
    code = errorData[0]['extensions']['code'];
    _setErrorMessage(errorData[0]['message']);
  }


  ///
  /// Determine the client-friendly error message based on the [incomingMessage]
  ///
  _setErrorMessage(String incomingMessage) {

    print(incomingMessage);

    if (incomingMessage.contains('IncorrectPasswordError')) {
      message = 'Looks like you punched in the wrong password. Try again.';
    } else if (incomingMessage.contains('not a valid email address')) {
      message = 'Please enter a valid email address.';
    } else if (incomingMessage.contains('Expected type String')) {
      message = 'Please fill out all of the fields.';
    } else if (incomingMessage.contains('MissingPasswordError')) {
      message = 'Please enter a password.';
    } else {
      message = incomingMessage;
    }
  }

  String toString() => "Error => $code : $path : $message";
}
