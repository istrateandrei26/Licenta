import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:social_app/Models/place_autocomplete_location.dart';
import 'package:social_app/Models/place_autocomplete_suggestion.dart';
// import 'package:social_app/utilities/constants.dart';

import '../.env';

import 'network_service.dart';

class GooglePlaceService {
  static Future<List<PlaceAutocompleteSuggestion>> fetchAutocompleteSuggestions(
      String query) async {
    // build request with place autocomplete API URI
    Uri uri = Uri.https(
        "maps.googleapis.com",
        'maps/api/place/autocomplete/json',
        {"input": query, "key": googleAPIkey});

    // make GET request:

    String? response = await NetworkService.fetchUrl(uri);
    if (response != null) {
      // print(response);

      final predictions = jsonDecode(response)['predictions'] as List<dynamic>;
      var results = predictions
          .map((p) => PlaceAutocompleteSuggestion.fromJson(p))
          .toList();
      return results;
    } else {
      throw Exception('Failed to fetch autocomplete suggestions');
    }
  }

  static Future<PlaceAutocompleteLocation> fetchLocation(String placeId) async {
    Uri uri = Uri.https("maps.googleapis.com", 'maps/api/place/details/json', {
      "place_id": placeId,
      // "fields": "geometry",
      "key": googleAPIkey
    });

    String? response = await NetworkService.fetchUrl(uri);

    if (response != null) {
      final result = jsonDecode(response)['result'] as Map<String, dynamic>;

      var location = PlaceAutocompleteLocation.fromJson(result);
      return location;
    } else {
      throw Exception('Failed to fetch location');
    }
  }

  static Future<PlaceAutocompleteLocation> getLocationInfoByCoordinates(
      double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    var locality = placemarks.reversed.last.locality;
    var street = placemarks.reversed.last.street;

    return PlaceAutocompleteLocation(
        city: locality!, locationName: street!, lat: lat, lng: long);
  }
}
