import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/coordinates.g.dart';


@JsonSerializable(explicitToJson: true)
class Coordinates {
  final int id;
  final double latitude;
  final double longitude;

  Coordinates(this.id, this.latitude, this.longitude);

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}