class RemoveGoogleCalendarEventRequest {
  final int userId;
  final int eventId;

  RemoveGoogleCalendarEventRequest(this.userId, this.eventId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
    'eventId': eventId
  };
}
