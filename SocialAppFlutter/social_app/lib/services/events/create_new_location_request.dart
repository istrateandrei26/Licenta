class CreateNewLocationRequest {
  final double latitude;
  final double longitude;
  final String city;
  final String locationName;

  CreateNewLocationRequest(this.latitude, this.longitude, this.city, this.locationName);

  Map<String, dynamic> toJson() => 
  {
    'latitude': latitude,
    'longitude': longitude,
    'city': city,
    'locationName': locationName
  };
}
