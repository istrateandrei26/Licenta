// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      json['id'] as int,
      DateTime.parse(json['startDateTime'] as String),
      (json['duration'] as num).toDouble(),
      SportCategory.fromJson(json['sportCategory'] as Map<String, dynamic>),
      Location.fromJson(json['location'] as Map<String, dynamic>),
      User.fromJson(json['creator'] as Map<String, dynamic>),
      json['requiredMembersTotal'] as int,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'duration': instance.duration,
      'sportCategory': instance.sportCategory.toJson(),
      'location': instance.location.toJson(),
      'creator': instance.creator.toJson(),
      'requiredMembersTotal': instance.requiredMembersTotal,
    };
