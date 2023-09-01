import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/last_message.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/add_user_to_chat_group_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AddUserToChatGroupModel {
  final int userWhoAdded;
  final List<User> newGroupPartnerList;
  final LastMessage chatListItem;
  final List<User> addedUsers;

  AddUserToChatGroupModel(
      this.userWhoAdded, this.newGroupPartnerList, this.chatListItem, this.addedUsers);

  factory AddUserToChatGroupModel.fromJson(Map<String, dynamic> json) =>
      _$AddUserToChatGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddUserToChatGroupModelToJson(this);
}
