// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    FriendRequest(
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['friendRequestId'] as int,
      json['accepted'] as bool,
    );

Map<String, dynamic> _$FriendRequestToJson(FriendRequest instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'friendRequestId': instance.friendRequestId,
      'accepted': instance.accepted,
    };
