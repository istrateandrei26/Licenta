// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../get_user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserProfileResponse _$GetUserProfileResponseFromJson(
        Map<String, dynamic> json) =>
    GetUserProfileResponse(
      json['statusCode'] as int,
      json['message'] as String,
      $enumDecode(_$TypeEnumMap, json['type']),
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['isFriend'] as bool,
      (json['eventsAttended'] as List<dynamic>)
          .map((e) => AttendedEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['admirers'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['myOwnEvents'] as List<dynamic>)
          .map((e) => EventAndRatingAverage.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['honors'] as int,
      json['givenHonors'] as int,
      (json['attendedCategories'] as List<dynamic>)
          .map((e) => AttendedCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['friendRequestSent'] as bool,
    );

Map<String, dynamic> _$GetUserProfileResponseToJson(
        GetUserProfileResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'type': _$TypeEnumMap[instance.type]!,
      'user': instance.user.toJson(),
      'isFriend': instance.isFriend,
      'eventsAttended': instance.eventsAttended.map((e) => e.toJson()).toList(),
      'admirers': instance.admirers.map((e) => e.toJson()).toList(),
      'myOwnEvents': instance.myOwnEvents.map((e) => e.toJson()).toList(),
      'honors': instance.honors,
      'givenHonors': instance.givenHonors,
      'attendedCategories':
          instance.attendedCategories.map((e) => e.toJson()).toList(),
      'friendRequestSent': instance.friendRequestSent,
    };

const _$TypeEnumMap = {
  Type.invalidUsernameOrPassword: 0,
  Type.ok: 1,
  Type.existingEmail: 2,
  Type.existingUsername: 3,
  Type.userNotFound: 4,
  Type.invalidTokenRequest: 5,
  Type.invalidOldPassword: 6,
  Type.eventExists: 7,
};
