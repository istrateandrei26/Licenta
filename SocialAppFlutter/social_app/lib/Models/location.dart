import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/coordinates.dart';

part 'json_generated_code/location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  final int id;
  final String city;
  final String locationName;
  final Coordinates coordinates;
  final bool mapChosen;

  Location(this.id, this.city, this.locationName, this.coordinates, this.mapChosen);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
