import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/sport_category.g.dart';

@JsonSerializable(explicitToJson: true)
class SportCategory {
  final int id;
  final String name;
  final String image;

  SportCategory(this.id, this.name, this.image);

  factory SportCategory.fromJson(Map<String, dynamic> json) =>
      _$SportCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SportCategoryToJson(this);
}
