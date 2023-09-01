import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/location.dart';
import 'package:social_app/Models/sport_category.dart';

part 'json_generated_code/attended_location.g.dart';

@JsonSerializable(explicitToJson: true)
class AttendedLocation {
  final Location location;
  final SportCategory sportCategory;
  final DateTime attendedDatetime;

  AttendedLocation(this.location, this.sportCategory, this.attendedDatetime);

  factory AttendedLocation.fromJson(Map<String, dynamic> json) =>
      _$AttendedLocationFromJson(json);

  Map<String, dynamic> toJson() => _$AttendedLocationToJson(this);
}
