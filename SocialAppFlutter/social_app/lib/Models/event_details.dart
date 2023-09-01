import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/user.dart';

class EventDetails {
  final Event? event;
  final List<User> members;

  EventDetails(this.event, this.members);
}
