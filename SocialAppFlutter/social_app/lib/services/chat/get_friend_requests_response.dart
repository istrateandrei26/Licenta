import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/Models/friend_request.dart';

part 'json_generated_code/get_friend_requests_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetFriendRequestsResponse extends BasicResponse {
  final List<FriendRequest> friendRequests;
  final int numberOfFriends;

  GetFriendRequestsResponse(
      super.statusCode, super.message, super.type, this.friendRequests, this.numberOfFriends);

  factory GetFriendRequestsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetFriendRequestsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetFriendRequestsResponseToJson(this);
}
