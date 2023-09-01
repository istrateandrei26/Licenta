// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../remove_message_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveMessageReaction _$RemoveMessageReactionFromJson(
        Map<String, dynamic> json) =>
    RemoveMessageReaction(
      json['messageId'] as int,
      json['conversationId'] as int,
      json['whoRemovedReaction'] as int,
    );

Map<String, dynamic> _$RemoveMessageReactionToJson(
        RemoveMessageReaction instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'conversationId': instance.conversationId,
      'whoRemovedReaction': instance.whoRemovedReaction,
    };
