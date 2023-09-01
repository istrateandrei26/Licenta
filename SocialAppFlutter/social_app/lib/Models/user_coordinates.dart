import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/user_coordinates.g.dart';

@JsonSerializable(explicitToJson: true)
class UserCoordinates {
  final double latitude;
  final double longitude;
  final DateTime lastFetchedLocationTime;

  UserCoordinates(this.latitude, this.longitude, this.lastFetchedLocationTime);

  factory UserCoordinates.fromJson(Map<String, dynamic> json) =>
      _$UserCoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$UserCoordinatesToJson(this);

}
