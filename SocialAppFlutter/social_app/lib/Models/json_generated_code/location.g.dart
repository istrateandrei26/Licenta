// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      json['id'] as int,
      json['city'] as String,
      json['locationName'] as String,
      Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
      json['mapChosen'] as bool,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'locationName': instance.locationName,
      'coordinates': instance.coordinates.toJson(),
      'mapChosen': instance.mapChosen,
    };
