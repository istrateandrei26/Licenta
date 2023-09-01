import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/Models/coordinates.dart';
import 'package:social_app/Models/sport_category.dart';

part 'json_generated_code/get_new_requested_location_info_for_payment_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetNewRequestedLocationInfoForPaymentResponse extends BasicResponse {
  final SportCategory? sportCategory;
  final Coordinates? coordinates;
  final String city;
  final String locationName;
  final int? approvedLocationId;
  final String ownerEmail;
  final bool found;
  final bool alreadyUsed;

  GetNewRequestedLocationInfoForPaymentResponse(
      super.statusCode,
      super.message,
      super.type,
      this.sportCategory,
      this.coordinates,
      this.city,
      this.locationName,
      this.approvedLocationId,
      this.found, this.ownerEmail, this.alreadyUsed);

  factory GetNewRequestedLocationInfoForPaymentResponse.fromJson(
          Map<String, dynamic> json) =>
      _$GetNewRequestedLocationInfoForPaymentResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetNewRequestedLocationInfoForPaymentResponseToJson(this);
}
