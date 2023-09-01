import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/create_event_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateEventRequest {
  final int sportCategoryId;
  final int locationId;
  final int creatorId;
  final int requiredMembers;
  final List<int> allMembers;
  final DateTime startDatetime;
  final double duration;
  final bool createNewLocation;
  double lat = 0.0;
  double long = 0.0;
  String city = '';
  String locationName = '';

  CreateEventRequest(
      this.sportCategoryId,
      this.locationId,
      this.creatorId,
      this.requiredMembers,
      this.startDatetime,
      this.duration,
      this.allMembers,
      this.createNewLocation,
      this.lat,
      this.long,
      this.city,
      this.locationName);

  Map<String, dynamic> toJson() => _$CreateEventRequestToJson(this);
}
