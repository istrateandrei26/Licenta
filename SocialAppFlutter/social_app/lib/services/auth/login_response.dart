import 'package:json_annotation/json_annotation.dart';
import '../../Models/auth/basic_response.dart';

part 'json_generated_code/login_response.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginResponse extends BasicResponse {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String username;
  final String accessToken;
  final String refreshToken;
  final List<int>? profileImage;

  LoginResponse(
      int statusCode,
      String message,
      Type type,
      this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.username,
      this.accessToken,
      this.refreshToken, this.profileImage)
      : super(statusCode, message, type);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
