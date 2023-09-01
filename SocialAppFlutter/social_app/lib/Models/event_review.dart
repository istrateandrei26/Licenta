import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/user.dart';

import 'event_and_rating_average.dart';

part 'json_generated_code/event_review.g.dart';

@JsonSerializable(explicitToJson: true)
class EventReview {
  final User fromReview;
  final EventAndRatingAverage reviewedEvent;

  EventReview(this.fromReview, this.reviewedEvent);

  factory EventReview.fromJson(Map<String, dynamic> json) =>
      _$EventReviewFromJson(json);

  Map<String, dynamic> toJson() => _$EventReviewToJson(this);
}
