// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['id'] as int,
      (json['groupImage'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['groupName'] as String,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'groupImage': instance.groupImage,
      'groupName': instance.groupName,
    };
