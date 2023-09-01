import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/chat_group_leaving_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatGroupLeavingModel {
  final int conversationId;
  final int userId;
  final String newGroupName;

  ChatGroupLeavingModel(this.conversationId, this.userId, this.newGroupName);

  factory ChatGroupLeavingModel.fromJson(Map<String, dynamic> json) =>
      _$ChatGroupLeavingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatGroupLeavingModelToJson(this);
}
