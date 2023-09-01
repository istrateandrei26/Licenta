import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/upload_profile_image_response.g.dart';

@JsonSerializable(explicitToJson: true)
class UploadProfileImageResponse extends BasicResponse {
  final List<int> profileImage;

  UploadProfileImageResponse(
      super.statusCode, super.message, super.type, this.profileImage);

  factory UploadProfileImageResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadProfileImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadProfileImageResponseToJson(this);
}
