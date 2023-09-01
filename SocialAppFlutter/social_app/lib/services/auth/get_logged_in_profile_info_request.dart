class GetLoggedInProfileInfoRequest {
  final int userId;

  GetLoggedInProfileInfoRequest(this.userId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
  };
}