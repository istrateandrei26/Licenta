import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/change_password_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ChangePasswordResponse extends BasicResponse {
  ChangePasswordResponse(super.statusCode, super.message, super.type);

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}



