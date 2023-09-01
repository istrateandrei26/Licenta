// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventReview _$EventReviewFromJson(Map<String, dynamic> json) => EventReview(
      User.fromJson(json['fromReview'] as Map<String, dynamic>),
      EventAndRatingAverage.fromJson(
          json['reviewedEvent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventReviewToJson(EventReview instance) =>
    <String, dynamic>{
      'fromReview': instance.fromReview.toJson(),
      'reviewedEvent': instance.reviewedEvent.toJson(),
    };
