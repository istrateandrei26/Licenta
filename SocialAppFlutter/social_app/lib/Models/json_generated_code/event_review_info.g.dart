// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event_review_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventReviewInfo _$EventReviewInfoFromJson(Map<String, dynamic> json) =>
    EventReviewInfo(
      Event.fromJson(json['event'] as Map<String, dynamic>),
      (json['members'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventReviewInfoToJson(EventReviewInfo instance) =>
    <String, dynamic>{
      'event': instance.event.toJson(),
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
