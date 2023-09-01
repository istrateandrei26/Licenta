import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/sport_category.dart';

part 'json_generated_code/retrieve_events_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RetrieveEventsResponse extends BasicResponse {
  final List<Event> events;
  final List<SportCategory> categories;

  RetrieveEventsResponse(
      super.statusCode, super.message, super.type, this.events, this.categories);

  factory RetrieveEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveEventsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveEventsResponseToJson(this);
}
