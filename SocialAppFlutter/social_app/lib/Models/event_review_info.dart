import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/user.dart';
part 'json_generated_code/event_review_info.g.dart';

@JsonSerializable(explicitToJson: true)
class EventReviewInfo {
  final Event event;
  final List<User> members;

  EventReviewInfo(this.event, this.members);

  factory EventReviewInfo.fromJson(Map<String, dynamic> json) =>
      _$EventReviewInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EventReviewInfoToJson(this);
}
