import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/add_device_id_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AddDeviceIdResponse extends BasicResponse {
  AddDeviceIdResponse(super.statusCode, super.message, super.type);

  factory AddDeviceIdResponse.fromJson(Map<String, dynamic> json) =>
      _$AddDeviceIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddDeviceIdResponseToJson(this);
}
