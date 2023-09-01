// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../chat_group_leaving_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatGroupLeavingModel _$ChatGroupLeavingModelFromJson(
        Map<String, dynamic> json) =>
    ChatGroupLeavingModel(
      json['conversationId'] as int,
      json['userId'] as int,
      json['newGroupName'] as String,
    );

Map<String, dynamic> _$ChatGroupLeavingModelToJson(
        ChatGroupLeavingModel instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'userId': instance.userId,
      'newGroupName': instance.newGroupName,
    };
