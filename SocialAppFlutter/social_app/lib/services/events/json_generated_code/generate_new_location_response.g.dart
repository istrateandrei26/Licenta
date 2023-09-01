// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../generate_new_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateNewLocationResponse _$GenerateNewLocationResponseFromJson(
        Map<String, dynamic> json) =>
    GenerateNewLocationResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      json['success'] as bool,
    );

Map<String, dynamic> _$GenerateNewLocationResponseToJson(
        GenerateNewLocationResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'success': instance.success,
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
