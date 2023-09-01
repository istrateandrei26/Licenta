class GetGoogleCalendarEventRequest {
  final int userId;
  final int eventId;

  GetGoogleCalendarEventRequest(this.userId, this.eventId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
    'eventId': eventId
  };
}
