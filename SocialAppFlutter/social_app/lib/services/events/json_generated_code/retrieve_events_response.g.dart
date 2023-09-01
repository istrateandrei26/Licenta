// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../retrieve_events_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveEventsResponse _$RetrieveEventsResponseFromJson(
        Map<String, dynamic> json) =>
    RetrieveEventsResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['categories'] as List<dynamic>)
          .map((e) => SportCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RetrieveEventsResponseToJson(
        RetrieveEventsResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'events': instance.events.map((e) => e.toJson()).toList(),
      'categories': instance.categories.map((e) => e.toJson()).toList(),
    };

const _$TypeEnumMap = {
  Type.invalidUsernameOrPassword: 0,
  Type.ok: 1,
  Type.existingEmail: 2,
  Type.existingUsername: 3,
  Type.userNotFound: 4,
  Type.invalidTokenRequest: 5,
};
