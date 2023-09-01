// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../retrieve_event_review_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveEventReviewInfoResponse _$RetrieveEventReviewInfoResponseFromJson(
        Map<String, dynamic> json) =>
    RetrieveEventReviewInfoResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['eventReviewInfos'] as List<dynamic>)
          .map((e) => EventReviewInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RetrieveEventReviewInfoResponseToJson(
        RetrieveEventReviewInfoResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'eventReviewInfos':
          instance.eventReviewInfos.map((e) => e.toJson()).toList(),
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
