// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../check_event_to_join_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckEventToJoinResponse _$CheckEventToJoinResponseFromJson(
        Map<String, dynamic> json) =>
    CheckEventToJoinResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      json['busy'] as bool,
      json['expired'] as bool,
      json['full'] as bool,
    );

Map<String, dynamic> _$CheckEventToJoinResponseToJson(
        CheckEventToJoinResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'busy': instance.busy,
      'expired': instance.expired,
      'full': instance.full,
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
