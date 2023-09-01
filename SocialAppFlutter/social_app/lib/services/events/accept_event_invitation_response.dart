import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/accept_event_invitation_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AcceptEventInvitationResponse extends BasicResponse {
  final bool busy;
  final bool expired;
  final bool full;
  AcceptEventInvitationResponse(
      super.statusCode, super.message, super.type, this.busy, this.expired, this.full);

  factory AcceptEventInvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$AcceptEventInvitationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptEventInvitationResponseToJson(this);
}
