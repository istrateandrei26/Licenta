import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/confirm_new_location_payment_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ConfirmNewLocationPaymentResponse extends BasicResponse {
  ConfirmNewLocationPaymentResponse(
      super.statusCode, super.message, super.type);

  factory ConfirmNewLocationPaymentResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ConfirmNewLocationPaymentResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ConfirmNewLocationPaymentResponseToJson(this);
}
