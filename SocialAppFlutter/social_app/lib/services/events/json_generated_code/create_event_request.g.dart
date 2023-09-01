// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../create_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: unused_element
CreateEventRequest _$CreateEventRequestFromJson(Map<String, dynamic> json) =>
    CreateEventRequest(
      json['sportCategoryId'] as int,
      json['locationId'] as int,
      json['creatorId'] as int,
      json['requiredMembers'] as int,
      DateTime.parse(json['startDatetime'] as String),
      (json['duration'] as num).toDouble(),
      (json['allMembers'] as List<dynamic>).map((e) => e as int).toList(),
      json['createNewLocation'] as bool,
      (json['lat'] as num).toDouble(),
      (json['long'] as num).toDouble(),
      json['city'] as String,
      json['locationName'] as String,
    );

Map<String, dynamic> _$CreateEventRequestToJson(CreateEventRequest instance) =>
    <String, dynamic>{
      'sportCategoryId': instance.sportCategoryId,
      'locationId': instance.locationId,
      'creatorId': instance.creatorId,
      'requiredMembers': instance.requiredMembers,
      'allMembers': instance.allMembers,
      'startDatetime': instance.startDatetime.toIso8601String(),
      'duration': instance.duration,
      'createNewLocation': instance.createNewLocation,
      'lat': instance.lat,
      'long': instance.long,
      'city': instance.city,
      'locationName': instance.locationName,
    };
