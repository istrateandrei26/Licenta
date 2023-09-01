// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../get_friend_requests_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFriendRequestsResponse _$GetFriendRequestsResponseFromJson(
        Map<String, dynamic> json) =>
    GetFriendRequestsResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['friendRequests'] as List<dynamic>)
          .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['numberOfFriends'] as int,
    );

Map<String, dynamic> _$GetFriendRequestsResponseToJson(
        GetFriendRequestsResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'friendRequests': instance.friendRequests.map((e) => e.toJson()).toList(),
      'numberOfFriends': instance.numberOfFriends,
    };

const _$TypeEnumMap = {
  Type.invalidUsernameOrPassword: 0,
  Type.ok: 1,
  Type.existingEmail: 2,
  Type.existingUsername: 3,
  Type.userNotFound: 4,
  Type.invalidTokenRequest: 5,
};
