class GetFriendRequestsRequest {
  final int userId;

  GetFriendRequestsRequest(this.userId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
  };
}