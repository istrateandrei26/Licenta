// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as int?,
      fromUser: json['fromUser'] as int,
      toUser: json['toUser'] as int?,
      content: json['content'] as String,
      datetime: DateTime.parse(json['datetime'] as String),
      conversationId: json['conversationId'] as int,
      isImage: json['isImage'] as bool,
      isVideo: json['isVideo'] as bool,
      fromUserDetails: json['fromUserDetails'] == null
          ? null
          : User.fromJson(json['fromUserDetails'] as Map<String, dynamic>),
      usersWhoReacted: (json['usersWhoReacted'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'fromUser': instance.fromUser,
      'toUser': instance.toUser,
      'content': instance.content,
      'datetime': instance.datetime.toIso8601String(),
      'conversationId': instance.conversationId,
      'isImage': instance.isImage,
      'isVideo': instance.isVideo,
      'fromUserDetails': instance.fromUserDetails?.toJson(),
      'usersWhoReacted':
          instance.usersWhoReacted.map((e) => e.toJson()).toList(),
    };
