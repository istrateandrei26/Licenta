// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event_invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventInvitation _$EventInvitationFromJson(Map<String, dynamic> json) =>
    EventInvitation(
      json['id'] as int,
      User.fromJson(json['fromUser'] as Map<String, dynamic>),
      User.fromJson(json['toUser'] as Map<String, dynamic>),
      Event.fromJson(json['event'] as Map<String, dynamic>),
      json['accepted'] as bool,
    );

Map<String, dynamic> _$EventInvitationToJson(EventInvitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUser': instance.fromUser.toJson(),
      'toUser': instance.toUser.toJson(),
      'event': instance.event.toJson(),
      'accepted': instance.accepted,
    };
