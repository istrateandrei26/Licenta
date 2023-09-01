// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../sport_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SportCategory _$SportCategoryFromJson(Map<String, dynamic> json) =>
    SportCategory(
      json['id'] as int,
      json['name'] as String,
      json['image'] as String,
    );

Map<String, dynamic> _$SportCategoryToJson(SportCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
