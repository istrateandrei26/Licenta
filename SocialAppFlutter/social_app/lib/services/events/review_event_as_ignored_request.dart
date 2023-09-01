class ReviewEventAsIgnoredRequest {
  final int eventId;
  final int fromId;

  ReviewEventAsIgnoredRequest(this.eventId, this.fromId);

  Map<String, dynamic> toJson() => 
  {
    'eventId': eventId,
    'fromId' : fromId
  };
  
}
