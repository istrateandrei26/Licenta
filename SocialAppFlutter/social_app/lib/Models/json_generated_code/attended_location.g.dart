// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../attended_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendedLocation _$AttendedLocationFromJson(Map<String, dynamic> json) =>
    AttendedLocation(
      Location.fromJson(json['location'] as Map<String, dynamic>),
      SportCategory.fromJson(json['sportCategory'] as Map<String, dynamic>),
      DateTime.parse(json['attendedDatetime'] as String),
    );

Map<String, dynamic> _$AttendedLocationToJson(AttendedLocation instance) =>
    <String, dynamic>{
      'location': instance.location.toJson(),
      'sportCategory': instance.sportCategory.toJson(),
      'attendedDatetime': instance.attendedDatetime.toIso8601String(),
    };
