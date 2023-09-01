import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/message.g.dart';

@JsonSerializable(explicitToJson: true)
class Message {
  final int? id;
  final int fromUser;
  final int? toUser;
  final String content;
  final DateTime datetime;
  final int conversationId;
  final bool isImage;
  final bool isVideo;
  final User? fromUserDetails;
  List<User> usersWhoReacted = [];

  Message(
      {this.id,
      required this.fromUser,
      this.toUser,
      required this.content,
      required this.datetime,
      required this.conversationId,
      required this.isImage,
      required this.isVideo,
      required this.fromUserDetails,
      required this.usersWhoReacted});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
