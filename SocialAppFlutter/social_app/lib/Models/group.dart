import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/group.g.dart';

@JsonSerializable(explicitToJson: true)
class Group {
  final int id;
  final List<int>? groupImage;
  final String groupName;

  Group(this.id, this.groupImage, this.groupName);

  factory Group.fromJson(Map<String, dynamic> json) =>
      _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
