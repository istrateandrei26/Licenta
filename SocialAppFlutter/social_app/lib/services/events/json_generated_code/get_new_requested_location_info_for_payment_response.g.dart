// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../get_new_requested_location_info_for_payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNewRequestedLocationInfoForPaymentResponse
    _$GetNewRequestedLocationInfoForPaymentResponseFromJson(
            Map<String, dynamic> json) =>
        GetNewRequestedLocationInfoForPaymentResponse(
          json['statusCode'] as int,
          json['message'] as String,
          $enumDecode(_$TypeEnumMap, json['type']),
          json['sportCategory'] == null
              ? null
              : SportCategory.fromJson(
                  json['sportCategory'] as Map<String, dynamic>),
          json['coordinates'] == null
              ? null
              : Coordinates.fromJson(
                  json['coordinates'] as Map<String, dynamic>),
          json['city'] as String,
          json['locationName'] as String,
          json['approvedLocationId'] as int?,
          json['found'] as bool,
          json['ownerEmail'] as String,
          json['alreadyUsed'] as bool,
        );

Map<String, dynamic> _$GetNewRequestedLocationInfoForPaymentResponseToJson(
        GetNewRequestedLocationInfoForPaymentResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'sportCategory': instance.sportCategory?.toJson(),
      'coordinates': instance.coordinates?.toJson(),
      'city': instance.city,
      'locationName': instance.locationName,
      'approvedLocationId': instance.approvedLocationId,
      'ownerEmail': instance.ownerEmail,
      'found': instance.found,
      'alreadyUsed': instance.alreadyUsed,
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
