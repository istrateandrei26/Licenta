// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../create_new_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateNewLocationResponse _$CreateNewLocationResponseFromJson(
        Map<String, dynamic> json) =>
    CreateNewLocationResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      json['locationId'] as int,
    );

Map<String, dynamic> _$CreateNewLocationResponseToJson(
        CreateNewLocationResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'locationId': instance.locationId,
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
