class GetFriendsRequest {
  final int userId;

  GetFriendsRequest(this.userId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
  };
}