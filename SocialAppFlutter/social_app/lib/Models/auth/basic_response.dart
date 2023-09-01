import 'package:json_annotation/json_annotation.dart';

enum Type {
  @JsonValue(0)
  invalidUsernameOrPassword(0),
  @JsonValue(1)
  ok(1),
  @JsonValue(2)
  existingEmail(2),
  @JsonValue(3)
  existingUsername(3),
  @JsonValue(4)
  userNotFound(4),
  @JsonValue(5)
  invalidTokenRequest(5),
  @JsonValue(6)
  invalidOldPassword(6),
  @JsonValue(7)
  eventExists(7);

  const Type(this.value);
  final int value;
}

class BasicResponse {
  final int statusCode;
  final String message;
  final Type type;

  BasicResponse(this.statusCode, this.message, this.type);
}
