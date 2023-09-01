import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/services/auth/login_response.dart';

part 'json_generated_code/get_logged_in_profile_info_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetLoggedInProfileInfoResponse extends LoginResponse {
  GetLoggedInProfileInfoResponse(
      super.statusCode,
      super.message,
      super.type,
      super.id,
      super.firstname,
      super.lastname,
      super.email,
      super.username,
      super.accessToken,
      super.refreshToken,
      super.profileImage);

  factory GetLoggedInProfileInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetLoggedInProfileInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetLoggedInProfileInfoResponseToJson(this);
}
