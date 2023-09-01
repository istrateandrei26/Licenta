import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/review_event_as_ignored_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewEventAsIgnoredResponse extends BasicResponse {
  ReviewEventAsIgnoredResponse(super.statusCode, super.message, super.type);

  factory ReviewEventAsIgnoredResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewEventAsIgnoredResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewEventAsIgnoredResponseToJson(this);
}
