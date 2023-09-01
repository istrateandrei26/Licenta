import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/Models/last_message.dart';

import '../../Models/user.dart';

part 'json_generated_code/retrieve_chatlist_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RetrieveChatListResponse extends BasicResponse {
  final List<LastMessage> lastMessages;
  final User user;
  final List<User> friends;
  final List<User> recommendedPersons;

  RetrieveChatListResponse(super.statusCode, super.message, super.type,
      this.friends, this.lastMessages, this.user, this.recommendedPersons);

  factory RetrieveChatListResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveChatListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveChatListResponseToJson(this);
}
