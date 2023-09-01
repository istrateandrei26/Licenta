import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/message.dart';

import '../../Models/auth/basic_response.dart';
import '../../Models/user.dart';

part 'json_generated_code/retrieve_messages_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RetrieveMessagesResponse extends BasicResponse {
  final List<Message> messages;
  final List<User> conversationPartners;
  List<int>? groupImage;
  String groupName;
  bool isGroup;
  final List<User> friends;

  RetrieveMessagesResponse(
      super.statusCode,
      super.message,
      super.type,
      this.messages,
      this.conversationPartners,
      this.groupImage,
      this.groupName,
      this.isGroup, this.friends);

  factory RetrieveMessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveMessagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveMessagesResponseToJson(this);
}
