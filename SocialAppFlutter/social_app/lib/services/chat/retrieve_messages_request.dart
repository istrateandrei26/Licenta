class RetrieveMessagesRequest {
  final int userId;
  final int conversationId;

  RetrieveMessagesRequest(this.userId, this.conversationId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
    'conversationId': conversationId
  };
}