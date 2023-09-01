import 'package:social_app/services/preferences_service.dart';
import 'dart:ui';

class UserSettings {
  static bool googleCalendarEnabled = false;
  static bool localCalendarEnabled = false;
  static String preferredLanguageCode = '';

  static Future setPreferredLanguage() async {
    var languageCode = await PreferencesService.getPreferredLanguage();

    String currentSystemUsedLanguage = window.locale.languageCode;

    if (languageCode != null) {
      preferredLanguageCode = languageCode;
    } else {
      preferredLanguageCode = currentSystemUsedLanguage;
    }
  }

  static Future setGoogleCalendarEnabled() async {
    var enabled = await PreferencesService.getGoogleCalendarEnabled();

    if (enabled != null) {
      googleCalendarEnabled = enabled;
    } else {
      googleCalendarEnabled = false;
    }
  }

  static Future setLocalCalendarEnabled() async {
    var enabled = await PreferencesService.getLocalCalendarEnabled();

    if (enabled != null) {
      localCalendarEnabled = enabled;
    } else {
      localCalendarEnabled = false;
    }
  }
}
