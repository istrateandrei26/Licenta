import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/friend_request.g.dart';

@JsonSerializable(explicitToJson: true)
class FriendRequest {
  final User user;
  final int friendRequestId;
  bool accepted;

  FriendRequest(this.user, this.friendRequestId, this.accepted);

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);
}
