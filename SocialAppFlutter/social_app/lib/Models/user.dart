import 'package:json_annotation/json_annotation.dart';

part 'json_generated_code/user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final int? id;
  final String? email;
  final String? firstname;
  final String? lastname;
  List<int>? profileImage;

  User(this.id, this.email, this.firstname, this.lastname, this.profileImage);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
