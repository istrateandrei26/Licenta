// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../last_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastMessage _$LastMessageFromJson(Map<String, dynamic> json) => LastMessage(
      userDetails: (json['userDetails'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int?,
      fromUser: json['fromUser'] as int,
      content: json['content'] as String,
      datetime: DateTime.parse(json['datetime'] as String),
      conversationId: json['conversationId'] as int,
      isImage: json['isImage'] as bool,
      isVideo: json['isVideo'] as bool,
      fromUserDetails: json['fromUserDetails'] == null
          ? null
          : User.fromJson(json['fromUserDetails'] as Map<String, dynamic>),
      conversationDescription: json['conversationDescription'] as String?,
      groupImage:
          (json['groupImage'] as List<dynamic>?)?.map((e) => e as int).toList(),
      isGroup: json['isGroup'] as bool,
      usersWhoReacted: (json['usersWhoReacted'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LastMessageToJson(LastMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUser': instance.fromUser,
      'content': instance.content,
      'datetime': instance.datetime.toIso8601String(),
      'conversationId': instance.conversationId,
      'isImage': instance.isImage,
      'isVideo': instance.isVideo,
      'fromUserDetails': instance.fromUserDetails?.toJson(),
      'usersWhoReacted':
          instance.usersWhoReacted.map((e) => e.toJson()).toList(),
      'userDetails': instance.userDetails.map((e) => e.toJson()).toList(),
      'conversationDescription': instance.conversationDescription,
      'groupImage': instance.groupImage,
      'isGroup': instance.isGroup,
    };
