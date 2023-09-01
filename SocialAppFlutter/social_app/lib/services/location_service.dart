import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:social_app/Models/coordinates.dart';
import 'package:social_app/Models/user_coordinates.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

const String LOCATION_DENIED = "LOCATION_DENIED";

class LocationService {
  static Future<UserCoordinates?> getUserLocation() async {
    // bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.denied) {
      //   // Permissions are denied, next time you could try
      //   // requesting permissions again (this is also where
      //   // Android's shouldShowRequestPermissionRationale
      //   // returned true. According to Android guidelines
      //   // your App should show an explanatory UI now.
      //   // return null;
      // }
    }

    while (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      await Geolocator.openLocationSettings();
      permission = await Geolocator.requestPermission();
    }

    // if (permission == LocationPermission.deniedForever) {
    //   // Permissions are denied forever, handle appropriately.
    //   // throw Exception(
    //   //     'Location permissions are permanently denied, we cannot request permissions.');
    //   return null;
    // }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();
    return UserCoordinates(
        position.latitude, position.longitude, position.timestamp!);
  }

  static Future<Coordinates?> getUserLocationWithLocationPlugin() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    return Coordinates(-1, _locationData.latitude!, _locationData.longitude!);
  }
}
