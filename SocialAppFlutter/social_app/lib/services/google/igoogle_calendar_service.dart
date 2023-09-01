import 'package:social_app/Models/calendar_event.dart';

abstract class IGoogleCalendarService {
  Future<String?> insertEventIntoCalendar(
      String accessToken, CalendarEvent event);
  Future<bool> checkOverlapEvent(
      String accessToken, DateTime start, DateTime end);

  Future deleteEventFromCalendar(
      String accessToken, String googleCalendarEventId);
}
