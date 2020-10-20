class Utility {


  ///
  /// Find a record out of a [list] by its [id]
  ///
  static findById(List list, String id) {

    for (final item in list) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }


  ///
  /// Format a [dateTime] to come out as "MM/dd/yyyy at hh:ii AM"
  ///
  static String formatDateTime(DateTime dateTime) {

    String hours = dateTime.hour.toString();
    String minutes = dateTime.minute.toString();
    String timeOfDay = 'AM';

    // Use PM
    if (dateTime.hour > 12) {
      hours = (dateTime.hour - 12).toString();
      timeOfDay = 'PM';
    }
    // Make midnight 12:00
    if (dateTime.hour == 0) {
      hours = (dateTime.hour + 12).toString();
    }
    // Add leading 0 to minutes less than 10
    if (dateTime.minute < 10) {
      minutes = "0${dateTime.minute.toString()}";
    }

    return "${dateTime.month}/${dateTime.day}/${dateTime.year} at $hours:$minutes $timeOfDay";
  }
}