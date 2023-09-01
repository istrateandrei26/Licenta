import 'package:device_calendar/device_calendar.dart';
import 'package:social_app/services/preferences_service.dart';

import '../Models/user_coordinates.dart';
import '../services/location_service.dart';

class UserLocationInfo {
  static UserCoordinates? userLocation;

  static Future<UserCoordinates?> getLocation() async {
    var userCoordinates = await LocationService.getUserLocation();

    if (userCoordinates == null) {
      await getLocation();
    }

    return userCoordinates;
  }

  static initializeLocationInfoForUser() async {
    var lastFetchedLocation = await PreferencesService.getUserCoordinates();
    if (lastFetchedLocation == null) {
      userLocation = await getLocation();
      await PreferencesService.setUserCoordinates(UserCoordinates(
          userLocation!.latitude, userLocation!.longitude, DateTime.now()));
    } else {
      var minutesDiff = DateTime.now()
          .difference(lastFetchedLocation.lastFetchedLocationTime)
          .inMinutes;

      if (minutesDiff > 5) {
        UserLocationInfo.userLocation = await getLocation();
        await PreferencesService.setUserCoordinates(UserCoordinates(
            userLocation!.latitude, userLocation!.longitude, DateTime.now()));
      } else {
        userLocation = lastFetchedLocation;
      }
    }
  }
}
