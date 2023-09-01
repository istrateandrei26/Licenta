import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/received_friend_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReceivedFriendRequestModel {
  final int id;
  final String firstname;
  final String lastname;
  List<int>? profileImage;
  final int friendRequestId;

  ReceivedFriendRequestModel(this.id, this.firstname, this.lastname,this.profileImage, this.friendRequestId);

  factory ReceivedFriendRequestModel.fromJson(Map<String, dynamic> json) => _$ReceivedFriendRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReceivedFriendRequestModelToJson(this);
}
