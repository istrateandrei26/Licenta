import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/remove_message_reaction.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoveMessageReaction {
  final int messageId;
  final int conversationId;
  final int whoRemovedReaction;

  RemoveMessageReaction(this.messageId, this.conversationId, this.whoRemovedReaction);

  factory RemoveMessageReaction.fromJson(Map<String, dynamic> json) =>
    _$RemoveMessageReactionFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveMessageReactionToJson(this);
}
