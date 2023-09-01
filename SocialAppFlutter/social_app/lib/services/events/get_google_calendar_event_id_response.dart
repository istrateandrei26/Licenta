import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/get_google_calendar_event_id_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetGoogleCalendarEventResponse extends BasicResponse {
  final String id;
  final bool found;

  GetGoogleCalendarEventResponse(super.statusCode, super.message, super.type, this.id, this.found);

  factory GetGoogleCalendarEventResponse.fromJson(Map<String, dynamic> json) =>
      _$GetGoogleCalendarEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetGoogleCalendarEventResponseToJson(this);
}
