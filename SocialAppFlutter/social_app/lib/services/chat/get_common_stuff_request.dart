class GetCommonStuffRequest {
  final int userId1;
  final int userId2;

  GetCommonStuffRequest(this.userId1, this.userId2);

  Map<String, dynamic> toJson() => 
  {
    'userId1': userId1,
    'userId2': userId2
  };
  
}
