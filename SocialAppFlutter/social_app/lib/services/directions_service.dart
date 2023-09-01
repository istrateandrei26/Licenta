import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_app/utilities/constants.dart';

import '../.env';

import '../Models/directions.dart';



class DirectionsService {
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";

  final Dio dio = Dio();

  Future<Directions?> getDirections(LatLng origin, LatLng destination) async {
    final response = await dio.get(_baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude}, ${destination.longitude}',
      'key': googleAPIkey
    });

    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
