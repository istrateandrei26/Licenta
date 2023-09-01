// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../retrieve_event_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveEventDetailsResponse _$RetrieveEventDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    RetrieveEventDetailsResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      Event.fromJson(json['event'] as Map<String, dynamic>),
      (json['members'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['friends'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RetrieveEventDetailsResponseToJson(
        RetrieveEventDetailsResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'event': instance.event.toJson(),
      'members': instance.members.map((e) => e.toJson()).toList(),
      'friends': instance.friends.map((e) => e.toJson()).toList(),
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
