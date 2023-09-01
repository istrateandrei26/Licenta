class AcceptEventInvitationRequest {
  final int invitationId;
  final int userId;

  AcceptEventInvitationRequest(this.invitationId, this.userId);

  Map<String, dynamic> toJson() => {
        'invitationId': invitationId,
        'userId': userId
  };
}
