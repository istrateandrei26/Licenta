class GetUserProfileRequest {
  final int currentUserId;
  final int userProfileId;

  GetUserProfileRequest(this.currentUserId, this.userProfileId);

  Map<String, dynamic> toJson() => 
  {
    'currentUserId': currentUserId,
    'userProfileId': userProfileId
  };
}