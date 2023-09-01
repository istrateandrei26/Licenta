import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/event_and_rating_average.g.dart';

@JsonSerializable(explicitToJson: true)
class EventAndRatingAverage {
  final Event event;
  double ratingAverage;
  final List<User> members;

  EventAndRatingAverage(this.event, this.ratingAverage, this.members);

  factory EventAndRatingAverage.fromJson(Map<String, dynamic> json) =>
      _$EventAndRatingAverageFromJson(json);

  Map<String, dynamic> toJson() => _$EventAndRatingAverageToJson(this);
}
