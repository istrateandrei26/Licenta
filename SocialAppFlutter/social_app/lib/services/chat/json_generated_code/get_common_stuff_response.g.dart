// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../get_common_stuff_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCommonStuffResponse _$GetCommonStuffResponseFromJson(
        Map<String, dynamic> json) =>
    GetCommonStuffResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['commonAttendedCategories'] as List<dynamic>)
          .map((e) => AttendedCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['commonGroups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetCommonStuffResponseToJson(
        GetCommonStuffResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'commonAttendedCategories':
          instance.commonAttendedCategories.map((e) => e.toJson()).toList(),
      'commonGroups': instance.commonGroups.map((e) => e.toJson()).toList(),
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
