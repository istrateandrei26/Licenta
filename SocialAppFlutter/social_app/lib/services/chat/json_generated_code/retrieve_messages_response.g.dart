// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../retrieve_messages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetrieveMessagesResponse _$RetrieveMessagesResponseFromJson(
        Map<String, dynamic> json) =>
    RetrieveMessagesResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['conversationPartners'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['groupImage'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['groupName'] as String,
      json['isGroup'] as bool,
      (json['friends'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RetrieveMessagesResponseToJson(
        RetrieveMessagesResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
      'conversationPartners':
          instance.conversationPartners.map((e) => e.toJson()).toList(),
      'groupImage': instance.groupImage,
      'groupName': instance.groupName,
      'isGroup': instance.isGroup,
      'friends': instance.friends.map((e) => e.toJson()).toList(),
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
