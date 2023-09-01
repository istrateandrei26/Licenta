// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../generate_password_reset_code_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneratePasswordResetCodeResponse _$GeneratePasswordResetCodeResponseFromJson(
        Map<String, dynamic> json) =>
    GeneratePasswordResetCodeResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      json['wrongEmail'] as bool,
    );

Map<String, dynamic> _$GeneratePasswordResetCodeResponseToJson(
        GeneratePasswordResetCodeResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'wrongEmail': instance.wrongEmail,
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
