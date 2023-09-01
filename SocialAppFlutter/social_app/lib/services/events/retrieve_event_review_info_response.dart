import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/event_review_info.dart';

import '../../Models/auth/basic_response.dart';

part 'json_generated_code/retrieve_event_review_info_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RetrieveEventReviewInfoResponse extends BasicResponse {
  final List<EventReviewInfo> eventReviewInfos;

  RetrieveEventReviewInfoResponse(super.statusCode, super.message, super.type, this.eventReviewInfos);

  factory RetrieveEventReviewInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveEventReviewInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveEventReviewInfoResponseToJson(this);

}
