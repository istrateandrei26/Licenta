class RetrieveEventInvitesRequest {
  final int userId;

  RetrieveEventInvitesRequest(this.userId);
  
  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
  };

}
