import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/event_invitation.g.dart';

@JsonSerializable(explicitToJson: true)
class EventInvitation {
  final int id;
  final User fromUser;
  final User toUser;
  final Event event;
  bool accepted;
  bool processing = false;

  EventInvitation(
      this.id, this.fromUser, this.toUser, this.event, this.accepted);

  factory EventInvitation.fromJson(Map<String, dynamic> json) =>
      _$EventInvitationFromJson(json);

  Map<String, dynamic> toJson() => _$EventInvitationToJson(this);
}
