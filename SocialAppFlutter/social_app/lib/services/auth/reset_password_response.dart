import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/reset_password_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ResetPasswordResponse extends BasicResponse {
  final bool codeExpired;
  final bool codeAlreadyUsed;
  final bool codeDoesNotExist;
  ResetPasswordResponse(super.statusCode, super.message, super.type,
      this.codeExpired, this.codeAlreadyUsed, this.codeDoesNotExist);

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseToJson(this);
}
