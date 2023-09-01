import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/auth/basic_response.dart';

part 'json_generated_code/check_event_to_join_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckEventToJoinResponse extends BasicResponse {
  final bool busy;
  final bool expired;
  final bool full;

  factory CheckEventToJoinResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckEventToJoinResponseFromJson(json);

  CheckEventToJoinResponse(super.statusCode, super.message, super.type,
      this.busy, this.expired, this.full);

  Map<String, dynamic> toJson() => _$CheckEventToJoinResponseToJson(this);
}
