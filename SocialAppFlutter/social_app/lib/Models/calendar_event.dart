class CalendarEvent {
  final String summary;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  CalendarEvent(this.summary, this.startTime, this.endTime, this.location);

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'start': {'dateTime': startTime.toUtc().toIso8601String()},
        'end': {'dateTime': endTime.toUtc().toIso8601String()},
        'location': location,
        'guestsCanModify': false,
        // 'transparency': 'opaque',
        // 'visibility': 'default',
        'locked': true,
        'reminders': {
        'useDefault': false,
        'overrides': [
            {'method': 'popup', 'minutes': 10}
          ]
        },
    };
}
