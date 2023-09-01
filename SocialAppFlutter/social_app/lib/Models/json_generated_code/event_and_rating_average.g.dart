// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event_and_rating_average.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAndRatingAverage _$EventAndRatingAverageFromJson(
        Map<String, dynamic> json) =>
    EventAndRatingAverage(
      Event.fromJson(json['event'] as Map<String, dynamic>),
      (json['ratingAverage'] as num).toDouble(),
      (json['members'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventAndRatingAverageToJson(
        EventAndRatingAverage instance) =>
    <String, dynamic>{
      'event': instance.event.toJson(),
      'ratingAverage': instance.ratingAverage,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
