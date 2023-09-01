// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../attended_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendedCategory _$AttendedCategoryFromJson(Map<String, dynamic> json) =>
    AttendedCategory(
      SportCategory.fromJson(json['sportCategory'] as Map<String, dynamic>),
      json['honors'] as int,
    );

Map<String, dynamic> _$AttendedCategoryToJson(AttendedCategory instance) =>
    <String, dynamic>{
      'sportCategory': instance.sportCategory.toJson(),
      'honors': instance.honors,
    };
