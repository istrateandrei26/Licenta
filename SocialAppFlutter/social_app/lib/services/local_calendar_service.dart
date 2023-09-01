import 'package:add_2_calendar/add_2_calendar.dart';

class LocalCalendarService {
  Event buildEvent(String location, String sportCategoryName, DateTime startDatetime, double duration) {
    return Event(
      title: location,
      description: sportCategoryName,
      startDate: startDatetime,
      endDate: startDatetime.add(Duration(minutes: duration.toInt())),
      allDay: false,
      iosParams: const IOSParams(
        reminder: Duration(minutes: 40),
      ),
      androidParams: const AndroidParams(
      ),
    );
  }


  addEventToLocalCalendar(String location, String sportCategoryName, DateTime startDatetime, double duration) {
    Add2Calendar.addEvent2Cal(
      buildEvent(location, sportCategoryName, startDatetime, duration),
    );
  }
}
