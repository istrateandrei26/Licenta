import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/group_image_transport.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupImageTransport {
  final int groupId;
  final List<int> groupImage;

  GroupImageTransport(this.groupId, this.groupImage);

  factory GroupImageTransport.fromJson(Map<String, dynamic> json) =>
      _$GroupImageTransportFromJson(json);

  Map<String, dynamic> toJson() => _$GroupImageTransportToJson(this);
}
