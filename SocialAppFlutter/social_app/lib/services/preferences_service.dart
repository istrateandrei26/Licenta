import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Models/user_coordinates.dart';

class PreferencesService {
  static Future<void> setPreferredLanguage(String languageCode) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString('languageCode', languageCode);
  }

  static Future<String?> getPreferredLanguage() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    final value = pref.getString('languageCode');

    if (value == null) return null;

    return value;
  }


  static Future<void> setUserCoordinates(UserCoordinates coordinates) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    String jsonString = json.encode(coordinates.toJson());

    pref.setString('coordinates', jsonString);
  }

  static Future<UserCoordinates?> getUserCoordinates() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    final value = pref.getString('coordinates');

    if (value == null) return null;

    return UserCoordinates.fromJson(json.decode(value));
  }

  static Future<void> setGoogleCalendarEnabled(bool enabled) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setBool("googleCalendarEnabled", enabled);
  }

  static Future<void> setLocalCalendarEnabled(bool enabled) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setBool("localCalendarEnabled", enabled);
  }

  static Future<bool?> getGoogleCalendarEnabled() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    var enabled = pref.getBool("googleCalendarEnabled");

    return enabled;
  }

  static Future<bool?> getLocalCalendarEnabled() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    var enabled = pref.getBool("localCalendarEnabled");

    return enabled;
  }

  static Future removeCalendarSettings() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove("googleCalendarEnabled");
    pref.remove("localCalendarEnabled");
  }

  static Future removeCachedCoordinates() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove("coordinates");
  }

  static Future removeSavedLanguage() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove("languageCode");
  }
}
