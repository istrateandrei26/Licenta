// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../accept_event_invitation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptEventInvitationResponse _$AcceptEventInvitationResponseFromJson(
        Map<String, dynamic> json) =>
    AcceptEventInvitationResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      json['busy'] as bool,
      json['expired'] as bool,
      json['full'] as bool
    );

Map<String, dynamic> _$AcceptEventInvitationResponseToJson(
        AcceptEventInvitationResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'busy': instance.busy,
      'expired': instance.expired,
      'full': instance.full
    };

const _$TypeEnumMap = {
  Type.invalidUsernameOrPassword: 0,
  Type.ok: 1,
  Type.existingEmail: 2,
  Type.existingUsername: 3,
  Type.userNotFound: 4,
  Type.invalidTokenRequest: 5,
  Type.invalidOldPassword: 6,
  Type.eventExists: 7,
};
