import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/attended_category.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/Models/group.dart';

part 'json_generated_code/get_common_stuff_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetCommonStuffResponse extends BasicResponse {
  final List<AttendedCategory> commonAttendedCategories;
  final List<Group> commonGroups;

  GetCommonStuffResponse(super.statusCode, super.message, super.type,
      this.commonAttendedCategories, this.commonGroups);

  factory GetCommonStuffResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCommonStuffResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCommonStuffResponseToJson(this);
}
