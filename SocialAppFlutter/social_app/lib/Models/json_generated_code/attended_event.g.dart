// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../attended_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendedEvent _$AttendedEventFromJson(Map<String, dynamic> json) =>
    AttendedEvent(
      Event.fromJson(json['event'] as Map<String, dynamic>),
      (json['members'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendedEventToJson(AttendedEvent instance) =>
    <String, dynamic>{
      'event': instance.event.toJson(),
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
