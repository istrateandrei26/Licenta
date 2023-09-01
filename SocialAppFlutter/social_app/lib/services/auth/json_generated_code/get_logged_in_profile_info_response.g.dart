// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../get_logged_in_profile_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetLoggedInProfileInfoResponse _$GetLoggedInProfileInfoResponseFromJson(
        Map<String, dynamic> json) =>
    GetLoggedInProfileInfoResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      json['id'] as int,
      json['firstname'] as String,
      json['lastname'] as String,
      json['email'] as String,
      json['username'] as String,
      json['accessToken'] as String,
      json['refreshToken'] as String,
      (json['profileImage'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$GetLoggedInProfileInfoResponseToJson(
        GetLoggedInProfileInfoResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'username': instance.username,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
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
