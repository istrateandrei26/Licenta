class CheckEventToJoinRequest {
  final int eventId;
  final int userId;

  CheckEventToJoinRequest(this.eventId, this.userId);

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'userId': userId
  };
}
