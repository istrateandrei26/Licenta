import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:social_app/Models/calendar_event.dart';
import 'package:social_app/services/google/igoogle_calendar_service.dart';
import 'package:http/http.dart' as http;

class GoogleCalendarService implements IGoogleCalendarService {
  final client = http.Client();

  @override
  Future<String?> insertEventIntoCalendar(
      String accessToken, CalendarEvent event) async {
    // var eventOverlaps =
    //     await checkOverlapEvent(accessToken, event.startTime, event.endTime);

    // if (eventOverlaps) return false;

    try {
      final response = await client.post(
        Uri.parse(
            'https://www.googleapis.com/calendar/v3/calendars/primary/events'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: json.encode(event.toJson()),
      );

      var responseJson = jsonDecode(response.body);
      String googleCalendarEventId = responseJson['id'];

      return googleCalendarEventId;
    } catch (e) {
      print(e.toString());

      return null;
    }

    // return true;
  }

  @override
  Future<bool> checkOverlapEvent(
      String accessToken, DateTime start, DateTime end) async {
    var startMin = DateTime(start.year, start.month, start.day);
    var startMax = DateTime(start.year, start.month, start.day, 23, 59);

    // final String rangeMin = startMin.toIso8601String();
    // final String rangeMax = startMax.toIso8601String();

    // Format the start and end times as RFC3339 strings
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    final rangeMin = formatter.format(startMin);
    final rangeMax = formatter.format(startMax);

    final String url =
        // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
        'https://www.googleapis.com/calendar/v3/calendars/primary/events' +
            '?timeMin=$rangeMin' +
            '&timeMax=$rangeMax' +
            '&singleEvents=true' +
            '&orderBy=startTime';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      //now take all events and check if one of them overlaps with ours:
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> events = data['items'];

      if (events.isNotEmpty) {
        for (final event in events) {
          final startEvent =
              DateTime.parse(event['start']['dateTime']).toLocal();
          final endEvent = DateTime.parse(event['end']['dateTime']).toLocal();
          // final String? eventTitle = event['summary'];

          bool overlaps = checkOverlap(start, startEvent, end, endEvent);

          if (overlaps) return true;
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return false;
  }

  bool checkOverlap(DateTime startDatetimeA, DateTime startDatetimeB,
      DateTime endDatetimeA, DateTime endDatetimeB) {
    var maxStartDateTime = startDatetimeA.isAfter(startDatetimeB)
        ? startDatetimeA
        : startDatetimeB;
    var minEndDateTime =
        endDatetimeA.isBefore(endDatetimeB) ? endDatetimeA : endDatetimeB;

    final bool overlaps = maxStartDateTime.isBefore(minEndDateTime);

    return overlaps;
  }

  @override
  Future deleteEventFromCalendar(
      String accessToken, String googleCalendarEventId) async {
    final String url =
        "https://www.googleapis.com/calendar/v3/calendars/primary/events/$googleCalendarEventId";

    try {
      await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },

        //204 if ok, 404 if event is not found, which is also ok
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
