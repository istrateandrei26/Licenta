import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/message_reaction.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageReaction {
  final int reactedMessageId;
  final int conversationId;
  final User whoReacted;

  MessageReaction(this.reactedMessageId, this.conversationId, this.whoReacted);

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
    _$MessageReactionFromJson(json);

  Map<String, dynamic> toJson() => _$MessageReactionToJson(this);
}
