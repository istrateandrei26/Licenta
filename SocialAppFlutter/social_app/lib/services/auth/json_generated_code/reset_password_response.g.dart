// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reset_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordResponse _$ResetPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      json['codeExpired'] as bool,
      json['codeAlreadyUsed'] as bool,
      json['codeDoesNotExist'] as bool,
    );

Map<String, dynamic> _$ResetPasswordResponseToJson(
        ResetPasswordResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'codeExpired': instance.codeExpired,
      'codeAlreadyUsed': instance.codeAlreadyUsed,
      'codeDoesNotExist': instance.codeDoesNotExist,
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
