// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../add_device_id_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddDeviceIdResponse _$AddDeviceIdResponseFromJson(Map<String, dynamic> json) =>
    AddDeviceIdResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
    );

Map<String, dynamic> _$AddDeviceIdResponseToJson(
        AddDeviceIdResponse instance) =>
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
