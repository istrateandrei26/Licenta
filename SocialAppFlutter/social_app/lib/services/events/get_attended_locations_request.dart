class GetAttendedLocationsRequest {
  final int userId;

  GetAttendedLocationsRequest(this.userId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
  };
}