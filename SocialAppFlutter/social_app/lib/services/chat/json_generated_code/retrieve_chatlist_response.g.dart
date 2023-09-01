// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../retrieve_chatlist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveChatListResponse _$RetrieveChatListResponseFromJson(
        Map<String, dynamic> json) =>
    RetrieveChatListResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['friends'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['lastMessages'] as List<dynamic>)
          .map((e) => LastMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      User.fromJson(json['user'] as Map<String, dynamic>),
      (json['recommendedPersons'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RetrieveChatListResponseToJson(
        RetrieveChatListResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'lastMessages': instance.lastMessages.map((e) => e.toJson()).toList(),
      'user': instance.user.toJson(),
      'friends': instance.friends.map((e) => e.toJson()).toList(),
      'recommendedPersons':
          instance.recommendedPersons.map((e) => e.toJson()).toList(),
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
