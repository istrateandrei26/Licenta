import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/attended_category.dart';
import 'package:social_app/Models/user.dart';

part 'json_generated_code/members_honor.g.dart';

@JsonSerializable(explicitToJson: true)
class MembersHonor {
  final User fromHonor;
  final AttendedCategory attendedCategory;

  MembersHonor(this.fromHonor, this.attendedCategory);

  factory MembersHonor.fromJson(Map<String, dynamic> json) =>
      _$MembersHonorFromJson(json);

  Map<String, dynamic> toJson() => _$MembersHonorToJson(this);
}
