class RetrieveEventDetailsRequest {
  final int eventId;
  final int userId;

  RetrieveEventDetailsRequest(this.eventId, this.userId);

  Map<String, dynamic> toJson() => 
  {
    'eventId': eventId,
    'userId': userId
  };
}
