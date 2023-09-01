import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/remove_device_id_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoveDeviceIdResponse extends BasicResponse {
  RemoveDeviceIdResponse(super.statusCode, super.message, super.type);

  factory RemoveDeviceIdResponse.fromJson(Map<String, dynamic> json) =>
      _$RemoveDeviceIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveDeviceIdResponseToJson(this);
}
