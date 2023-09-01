import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/attended_location.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/Models/location.dart';

part 'json_generated_code/retrieve_locations_by_sport_category_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RetrieveLocationsBySportCategoryResponse extends BasicResponse {
  final List<Location> locations;
  final List<AttendedLocation> attendedLocations;

  RetrieveLocationsBySportCategoryResponse(
      super.statusCode, super.message, super.type, this.locations, this.attendedLocations);
  
  factory RetrieveLocationsBySportCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveLocationsBySportCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveLocationsBySportCategoryResponseToJson(this);
}
