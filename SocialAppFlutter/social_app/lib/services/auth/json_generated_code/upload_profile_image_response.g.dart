// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../upload_profile_image_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadProfileImageResponse _$UploadProfileImageResponseFromJson(
        Map<String, dynamic> json) =>
    UploadProfileImageResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['profileImage'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$UploadProfileImageResponseToJson(
        UploadProfileImageResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'profileImage': instance.profileImage,
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
