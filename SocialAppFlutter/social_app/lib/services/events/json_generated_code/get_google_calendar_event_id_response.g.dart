// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../get_google_calendar_event_id_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGoogleCalendarEventResponse _$GetGoogleCalendarEventResponseFromJson(
        Map<String, dynamic> json) =>
    GetGoogleCalendarEventResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      json['id'] as String,
      json['found'] as bool,
    );

Map<String, dynamic> _$GetGoogleCalendarEventResponseToJson(
        GetGoogleCalendarEventResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'id': instance.id,
      'found': instance.found,
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
