import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/Models/event.dart';

import '../../Models/user.dart';

part 'json_generated_code/retrieve_event_details_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RetrieveEventDetailsResponse extends BasicResponse {
  final Event event;
  final List<User> members;
  final List<User> friends;

  RetrieveEventDetailsResponse(
      super.statusCode, super.message, super.type, this.event, this.members, this.friends);

  factory RetrieveEventDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveEventDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveEventDetailsResponseToJson(this);
}
