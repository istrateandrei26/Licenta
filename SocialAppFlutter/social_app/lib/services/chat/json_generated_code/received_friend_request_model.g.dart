// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../received_friend_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceivedFriendRequestModel _$ReceivedFriendRequestModelFromJson(
        Map<String, dynamic> json) =>
    ReceivedFriendRequestModel(
      json['id'] as int,
      json['firstname'] as String,
      json['lastname'] as String,
      (json['profileImage'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['friendRequestId'] as int,
    );

Map<String, dynamic> _$ReceivedFriendRequestModelToJson(
        ReceivedFriendRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'profileImage': instance.profileImage,
      'friendRequestId': instance.friendRequestId,
    };
