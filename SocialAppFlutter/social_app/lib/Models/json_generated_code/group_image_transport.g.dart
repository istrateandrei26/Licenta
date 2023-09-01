// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../group_image_transport.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupImageTransport _$GroupImageTransportFromJson(Map<String, dynamic> json) =>
    GroupImageTransport(
      json['groupId'] as int,
      (json['groupImage'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$GroupImageTransportToJson(
        GroupImageTransport instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'groupImage': instance.groupImage,
    };
