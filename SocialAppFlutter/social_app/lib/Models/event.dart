import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/location.dart';
import 'package:social_app/Models/sport_category.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/event.g.dart';

@JsonSerializable(explicitToJson: true)
class Event {
  final int id;
  final DateTime startDateTime;
  final double duration;
  final SportCategory sportCategory;
  final Location location;
  final User creator;
  final int requiredMembersTotal;

  Event(this.id, this.startDateTime, this.duration, this.sportCategory,
      this.location, this.creator, this.requiredMembersTotal);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
