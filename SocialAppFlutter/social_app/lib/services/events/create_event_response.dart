import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/create_event_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateEventResponse extends BasicResponse {
  final bool successfullyCreated;
  final int eventId;
  final bool overlaps;
  final bool busyCreator;

  CreateEventResponse(super.statusCode, super.message, super.type,
      this.successfullyCreated, this.eventId, this.overlaps, this.busyCreator);

  factory CreateEventResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEventResponseToJson(this);
}
