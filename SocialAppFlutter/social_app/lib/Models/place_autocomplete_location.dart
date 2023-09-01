class PlaceAutocompleteLocation {
  String city;
  String locationName;
  double lat;
  double lng;

  PlaceAutocompleteLocation({
    required this.city,
    required this.locationName,
    required this.lat,
    required this.lng,
  });

  factory PlaceAutocompleteLocation.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>;
    final location = geometry['location'] as Map<String, dynamic>;
    final addressComponents = json['address_components'] as List<dynamic>;
    final cityComponent = addressComponents.firstWhere((component) {
      final types = component['types'] as List<dynamic>;
      return types.contains('locality');
    }, orElse: () => null);
    final cityFound =
        cityComponent != null ? cityComponent['long_name'] as String : '';

    final locationName = json['name'] ?? '';

    return PlaceAutocompleteLocation(
      city: cityFound,
      locationName: locationName,
      lat: location['lat'] as double,
      lng: location['lng'] as double,
    );
  }
}
