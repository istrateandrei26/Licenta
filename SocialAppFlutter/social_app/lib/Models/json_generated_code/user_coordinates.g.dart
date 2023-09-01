// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_coordinates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCoordinates _$UserCoordinatesFromJson(Map<String, dynamic> json) =>
    UserCoordinates(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      DateTime.parse(json['lastFetchedLocationTime'] as String),
    );

Map<String, dynamic> _$UserCoordinatesToJson(UserCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'lastFetchedLocationTime':
          instance.lastFetchedLocationTime.toIso8601String(),
    };
