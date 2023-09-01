class AddGoogleCalendarEventRequest {
  final String googleCalendarEventId;
  final int userId;
  final int eventId;

  AddGoogleCalendarEventRequest(this.googleCalendarEventId, this.userId, this.eventId);
  
  Map<String, dynamic> toJson() => 
  {
    'googleCalendarEventId': googleCalendarEventId,
    'userId': userId,
    'eventId': eventId
  };
}
