import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/Models/event_invitation.dart';

part 'json_generated_code/retrieve_event_invites_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RetrieveEventInvitesResponse extends BasicResponse {
  final List<EventInvitation> invites;

  RetrieveEventInvitesResponse(
      super.statusCode, super.message, super.type, this.invites);

  factory RetrieveEventInvitesResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveEventInvitesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveEventInvitesResponseToJson(this);
}
