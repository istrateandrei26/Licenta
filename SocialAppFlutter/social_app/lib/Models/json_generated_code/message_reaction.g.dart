// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../message_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageReaction _$MessageReactionFromJson(Map<String, dynamic> json) =>
    MessageReaction(
      json['reactedMessageId'] as int,
      json['conversationId'] as int,
      User.fromJson(json['whoReacted'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageReactionToJson(MessageReaction instance) =>
    <String, dynamic>{
      'reactedMessageId': instance.reactedMessageId,
      'conversationId': instance.conversationId,
      'whoReacted': instance.whoReacted.toJson(),
    };
