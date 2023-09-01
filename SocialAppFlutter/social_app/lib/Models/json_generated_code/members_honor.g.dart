// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../members_honor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembersHonor _$MembersHonorFromJson(Map<String, dynamic> json) => MembersHonor(
      User.fromJson(json['fromHonor'] as Map<String, dynamic>),
      AttendedCategory.fromJson(
          json['attendedCategory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MembersHonorToJson(MembersHonor instance) =>
    <String, dynamic>{
      'fromHonor': instance.fromHonor.toJson(),
      'attendedCategory': instance.attendedCategory.toJson(),
    };
