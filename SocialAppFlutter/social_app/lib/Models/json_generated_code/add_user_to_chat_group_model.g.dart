// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../add_user_to_chat_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddUserToChatGroupModel _$AddUserToChatGroupModelFromJson(
        Map<String, dynamic> json) =>
    AddUserToChatGroupModel(
      json['userWhoAdded'] as int,
      (json['newGroupPartnerList'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      LastMessage.fromJson(json['chatListItem'] as Map<String, dynamic>),
      (json['addedUsers'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddUserToChatGroupModelToJson(
        AddUserToChatGroupModel instance) =>
    <String, dynamic>{
      'userWhoAdded': instance.userWhoAdded,
      'newGroupPartnerList':
          instance.newGroupPartnerList.map((e) => e.toJson()).toList(),
      'chatListItem': instance.chatListItem.toJson(),
      'addedUsers': instance.addedUsers.map((e) => e.toJson()).toList(),
    };
