

import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/register_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RegisterResponse extends BasicResponse{

  RegisterResponse(
      int statusCode,
      String message,
      Type type,
  )
      : super(statusCode, message, type);


  factory RegisterResponse.fromJson(Map<String, dynamic> json) => _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}