import 'package:flutter/material.dart';
import '../widgets/plainText.dart';
import '../resources/utility.dart';


class HangoutForm extends StatelessWidget {


  final String title;
  final String description;
  final String location;
  final int attendeeLimit;
  final DateTime dateTime;
  final Function setState;


  HangoutForm({
    this.title,
    this.description,
    this.location,
    this.attendeeLimit,
    this.dateTime,
    this.setState
  });


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        _titleField(),
        _descriptionField(),
        _locationField(),
        _attendeeLimitField(),
        _dateTimeField(context),
      ],
    );
  }


  Widget _titleField() {
    return TextFormField(
      initialValue: title,
      onChanged: (value) => setState('title', value),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Title',
      ),
    );
  }


  Widget _descriptionField() {
    return TextFormField(
      initialValue: description,
      onChanged: (value) => setState('description', value),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Description',
      ),
    );
  }


  Widget _locationField() {
    return TextFormField(
      initialValue: location,
      onChanged: (value) => setState('location', value),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Location',
      ),
    );
  }


  Widget _attendeeLimitField() {
    return TextFormField(
      initialValue: attendeeLimit == 0 ? null : attendeeLimit.toString(),
      onChanged: (value) => setState('attendeeLimit', int.parse(value)),
      decoration: InputDecoration(
        labelText: 'Attendee Limit',
      ),
      keyboardType: TextInputType.number
    );
  }


  Widget _dateTimeField(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          PlainText('Date/Time'),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: RaisedButton(
              child: Text(Utility.formatDateTime(dateTime)),
              onPressed: () async {
                DateTime date = await showDatePicker(
                  context: context,
                  initialDate: dateTime,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (date != null) {
                  TimeOfDay time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(dateTime)
                  );
                  setState('dateTime', DateTime(date.year, date.month, date.day, time.hour, time.minute));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
