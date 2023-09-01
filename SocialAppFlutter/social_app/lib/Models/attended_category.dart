import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/sport_category.dart';

part 'json_generated_code/attended_category.g.dart';

@JsonSerializable(explicitToJson: true)
class AttendedCategory {
  final SportCategory sportCategory;
  int honors;

  AttendedCategory(this.sportCategory, this.honors);

  factory AttendedCategory.fromJson(Map<String, dynamic> json) =>
      _$AttendedCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$AttendedCategoryToJson(this);
}
