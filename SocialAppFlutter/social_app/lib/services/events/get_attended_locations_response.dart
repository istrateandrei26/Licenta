import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/attended_location.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/get_attended_locations_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetAttendedLocationsResponse extends BasicResponse {
  final List<AttendedLocation> attendedLocations;

  GetAttendedLocationsResponse(
      super.statusCode, super.message, super.type, this.attendedLocations);

  factory GetAttendedLocationsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAttendedLocationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAttendedLocationsResponseToJson(this);
}
