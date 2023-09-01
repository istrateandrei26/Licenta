import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/generate_new_location_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GenerateNewLocationResponse extends BasicResponse {
  final bool success;

  GenerateNewLocationResponse(
      super.statusCode, super.message, super.type, this.success);

  factory GenerateNewLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$GenerateNewLocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateNewLocationResponseToJson(this);
}
