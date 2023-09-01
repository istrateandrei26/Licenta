// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../remove_google_calendar_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveGoogleCalendarEventResponse _$RemoveGoogleCalendarEventResponseFromJson(
        Map<String, dynamic> json) =>
    RemoveGoogleCalendarEventResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
    );

Map<String, dynamic> _$RemoveGoogleCalendarEventResponseToJson(
        RemoveGoogleCalendarEventResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
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
