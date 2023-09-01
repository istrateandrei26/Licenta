import 'package:json_annotation/json_annotation.dart';

import '../../Models/auth/basic_response.dart';
import '../../Models/user.dart';

part 'json_generated_code/get_friends_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetFriendsResponse extends BasicResponse {
  List<User> friends;

  GetFriendsResponse(super.statusCode, super.message, super.type, this.friends);

  factory GetFriendsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetFriendsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetFriendsResponseToJson(this);
}
