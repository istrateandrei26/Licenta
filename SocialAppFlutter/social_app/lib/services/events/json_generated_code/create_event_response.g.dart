// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../create_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateEventResponse _$CreateEventResponseFromJson(Map<String, dynamic> json) =>
    CreateEventResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      json['successfullyCreated'] as bool,
      json['eventId'] as int,
      json['overlaps'] as bool,
      json['busyCreator'] as bool,
    );

Map<String, dynamic> _$CreateEventResponseToJson(
        CreateEventResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'successfullyCreated': instance.successfullyCreated,
      'eventId': instance.eventId,
      'overlaps': instance.overlaps,
      'busyCreator': instance.busyCreator,
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
