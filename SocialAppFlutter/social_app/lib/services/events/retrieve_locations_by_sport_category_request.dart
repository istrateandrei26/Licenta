class RetrieveLocationsBySportCategoryRequest {
  final int userId;
  final int sportCategoryId;

  RetrieveLocationsBySportCategoryRequest(this.sportCategoryId, this.userId);

  Map<String, dynamic> toJson() => {
        'sportCategoryId': sportCategoryId,
        'userId': userId
      };
}
