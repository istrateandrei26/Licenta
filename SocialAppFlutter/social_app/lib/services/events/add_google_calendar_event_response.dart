import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/add_google_calendar_event_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AddGoogleCalendarEventResponse extends BasicResponse {
  AddGoogleCalendarEventResponse(super.statusCode, super.message, super.type);

  factory AddGoogleCalendarEventResponse.fromJson(Map<String, dynamic> json) =>
      _$AddGoogleCalendarEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddGoogleCalendarEventResponseToJson(this);
}
