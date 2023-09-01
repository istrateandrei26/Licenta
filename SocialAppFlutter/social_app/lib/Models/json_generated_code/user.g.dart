// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int?,
      json['email'] as String?,
      json['firstname'] as String?,
      json['lastname'] as String?,
      (json['profileImage'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'profileImage': instance.profileImage,
    };
