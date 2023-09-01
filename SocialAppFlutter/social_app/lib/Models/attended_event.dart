import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/attended_event.g.dart';

@JsonSerializable(explicitToJson: true)
class AttendedEvent {
  final Event event;
  final List<User> members;

  AttendedEvent(this.event, this.members);

  factory AttendedEvent.fromJson(Map<String, dynamic> json) =>
      _$AttendedEventFromJson(json);

  Map<String, dynamic> toJson() => _$AttendedEventToJson(this);
}
