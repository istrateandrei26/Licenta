import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/message.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/last_message.g.dart';

@JsonSerializable(explicitToJson: true)
class LastMessage extends Message {
  List<User> userDetails;
  String? conversationDescription;
  List<int>? groupImage;
  bool isGroup;
  LastMessage(
      {required this.userDetails,
      required super.id,
      required super.fromUser,
      required super.content,
      required super.datetime,
      required super.conversationId,
      required super.isImage,
      required super.isVideo,
      required super.fromUserDetails,
      required this.conversationDescription,
      required this.groupImage,
      required this.isGroup,
      required super.usersWhoReacted});

  factory LastMessage.fromJson(Map<String, dynamic> json) =>
      _$LastMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageToJson(this);
}
