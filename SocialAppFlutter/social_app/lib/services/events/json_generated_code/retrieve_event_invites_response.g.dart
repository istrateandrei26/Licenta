// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../retrieve_event_invites_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveEventInvitesResponse _$RetrieveEventInvitesResponseFromJson(
        Map<String, dynamic> json) =>
    RetrieveEventInvitesResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['invites'] as List<dynamic>)
          .map((e) => EventInvitation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RetrieveEventInvitesResponseToJson(
        RetrieveEventInvitesResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'invites': instance.invites.map((e) => e.toJson()).toList(),
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
