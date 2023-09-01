import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/generate_password_reset_code_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GeneratePasswordResetCodeResponse extends BasicResponse {
  final bool wrongEmail;

  GeneratePasswordResetCodeResponse(
      super.statusCode, super.message, super.type, this.wrongEmail);

  
  factory GeneratePasswordResetCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$GeneratePasswordResetCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeneratePasswordResetCodeResponseToJson(this);
}
