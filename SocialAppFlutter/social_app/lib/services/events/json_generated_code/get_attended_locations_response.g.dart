// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../get_attended_locations_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAttendedLocationsResponse _$GetAttendedLocationsResponseFromJson(
        Map<String, dynamic> json) =>
    GetAttendedLocationsResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['attendedLocations'] as List<dynamic>)
          .map((e) => AttendedLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAttendedLocationsResponseToJson(
        GetAttendedLocationsResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'attendedLocations':
          instance.attendedLocations.map((e) => e.toJson()).toList(),
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
