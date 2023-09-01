// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../retrieve_locations_by_sport_category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveLocationsBySportCategoryResponse
    _$RetrieveLocationsBySportCategoryResponseFromJson(
            Map<String, dynamic> json) =>
        RetrieveLocationsBySportCategoryResponse(
          json['statusCode'] as int,
          json['message'] as String,
          $enumDecode(_$TypeEnumMap, json['type']),
          (json['locations'] as List<dynamic>)
              .map((e) => Location.fromJson(e as Map<String, dynamic>))
              .toList(),
          (json['attendedLocations'] as List<dynamic>)
              .map((e) => AttendedLocation.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$RetrieveLocationsBySportCategoryResponseToJson(
        RetrieveLocationsBySportCategoryResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'locations': instance.locations.map((e) => e.toJson()).toList(),
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
