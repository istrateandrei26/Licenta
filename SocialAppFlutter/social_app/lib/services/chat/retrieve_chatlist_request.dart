class RetrieveChatListRequest {
  final int userId;

  RetrieveChatListRequest(this.userId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
  };
}
