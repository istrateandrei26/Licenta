class RetrieveEventReviewInfoRequest {
  final int userId;

  RetrieveEventReviewInfoRequest(this.userId);

  Map<String, dynamic> toJson() =>
  {
    'userId': userId
  };
}
