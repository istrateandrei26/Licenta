import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/remove_google_calendar_event_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoveGoogleCalendarEventResponse extends BasicResponse {
  RemoveGoogleCalendarEventResponse(
      super.statusCode, super.message, super.type);

  factory RemoveGoogleCalendarEventResponse.fromJson(
          Map<String, dynamic> json) =>
      _$RemoveGoogleCalendarEventResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RemoveGoogleCalendarEventResponseToJson(this);
}
