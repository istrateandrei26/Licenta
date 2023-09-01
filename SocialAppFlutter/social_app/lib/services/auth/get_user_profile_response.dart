import 'package:json_annotation/json_annotation.dart';
import 'package:social_app/Models/attended_category.dart';
import 'package:social_app/Models/attended_event.dart';
import 'package:social_app/Models/event_and_rating_average.dart';

import '../../Models/auth/basic_response.dart';
import '../../Models/user.dart';

part 'json_generated_code/get_user_profile_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetUserProfileResponse extends BasicResponse {
  final User user;
  final bool isFriend;
  final List<AttendedEvent> eventsAttended;
  final List<User> admirers;
  final List<EventAndRatingAverage> myOwnEvents;
  final int honors;
  final int givenHonors;
  final List<AttendedCategory> attendedCategories;
  final bool friendRequestSent;

  GetUserProfileResponse(
      int statusCode,
      String message,
      Type type,
      this.user,
      this.isFriend,
      this.eventsAttended,
      this.admirers,
      this.myOwnEvents,
      this.honors,
      this.givenHonors,
      this.attendedCategories, this.friendRequestSent)
      : super(statusCode, message, type);

  factory GetUserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserProfileResponseToJson(this);
}
