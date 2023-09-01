import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/create_new_location_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateNewLocationResponse extends BasicResponse {
  final int locationId;

  CreateNewLocationResponse(
      super.statusCode, super.message, super.type, this.locationId);

  factory CreateNewLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateNewLocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateNewLocationResponseToJson(this);
}
