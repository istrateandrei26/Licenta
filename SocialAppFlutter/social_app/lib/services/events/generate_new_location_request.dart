class GenerateNewLocationRequest {
  final String city;
  final String locationName;
  final double latitude;
  final double longitude;
  final String ownerEmail;
  final int sportCategoryId;

  GenerateNewLocationRequest(this.city, this.locationName, this.latitude, this.longitude, this.ownerEmail, this.sportCategoryId);

  Map<String, dynamic> toJson() => 
  {
    'city': city,
    'locationName': locationName,
    'latitude': latitude,
    'longitude': longitude,
    'ownerEmail': ownerEmail,
    'sportCategoryId': sportCategoryId
  };
}
