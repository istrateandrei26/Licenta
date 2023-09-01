import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/Models/attended_category.dart';
import 'package:social_app/Models/attended_event.dart';
import 'package:social_app/Models/event_review.dart';
import 'package:social_app/Models/members_honor.dart';
import 'package:social_app/services/auth/get_user_profile_response.dart';
import 'package:social_app/services/auth/upload_profile_image_response.dart';
import 'package:social_app/services/chat/chat_hub/chat_hub.dart';
import 'package:social_app/services/events/event_hub/event_hub.dart';
import 'package:social_app/services/iauth_service.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/service_locator/locator.dart';

import '../Models/event_and_rating_average.dart';
import '../Models/user.dart';

class UserProfileViewModel extends ChangeNotifier {
  User? _user;
  bool? _isFriend;
  bool _friendRequestSent = false;
  List<AttendedEvent> _eventsAttended = [];
  List<User> _admirers = [];
  List<EventAndRatingAverage> _myOwnEvents = [];
  int _honors = 0;
  int _givenHonors = 0;
  List<AttendedCategory> _attendedCategories = [];

  bool _processing = false;
  User? get user => _user;
  bool? get isFriend => _isFriend;
  bool get processing => _processing;
  bool get friendRequestSent => _friendRequestSent;
  List<AttendedEvent> get eventsAttended => _eventsAttended;
  List<User> get admirers => _admirers;
  List<EventAndRatingAverage> get myOwnEvents => _myOwnEvents;
  int get honors => _honors;
  int get givenHonors => _givenHonors;
  List<AttendedCategory> get attendedCategories => _attendedCategories;

  final ChatHub _chatHub = provider.get<ChatHub>();
  final EventHub _eventHub = provider.get<EventHub>();

  UserProfileViewModel() {
    _chatHub.addCreatedNewConversationWithFriend(
        "UserProfileViewModelCreatedNewConversationWithFriendHandler",
        (content, newNumberOfFriends, friendRequestId, newFriendContent) =>
            onAcceptedFriendRequest(content, newNumberOfFriends,
                friendRequestId, newFriendContent));

    _eventHub.addHonoredMemberHandler(
        "UserProfileViewModelAddedReceivedHonorHandler",
        (content) => onReceivedHonor(content));

    _eventHub.addReviewedOnlyEventHandler(
        "UserProfileViewModelReviewedOnlyEventHandler",
        (content) => onReceivedEventReview(content));
  }

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  updateAdmirers(User admirer) {
    if (!admirers.map((e) => e.id).contains(admirer.id)) {
      admirers.add(admirer);
      notifyListeners();
    }
  }

  updateAttendedCategories(AttendedCategory category) {
    if (attendedCategories
        .map((e) => e.sportCategory.id)
        .contains(category.sportCategory.id)) {
      var indexFound = attendedCategories.indexWhere(
          (element) => element.sportCategory.id == category.sportCategory.id);

      _attendedCategories[indexFound].honors = category.honors;
    } else {
      _attendedCategories.add(category);
    }

    notifyListeners();
  }

  setAttendedCategoriesWithHonors(List<AttendedCategory> attendedCategories) {
    attendedCategories.sort((b, a) => a.honors.compareTo(b.honors));

    _attendedCategories = attendedCategories;
    notifyListeners();
  }

  setHonors(int honors) {
    _honors = honors;
    notifyListeners();
  }

  setGivenHonors(int givenHonors) {
    _givenHonors = givenHonors;
    notifyListeners();
  }

  setEventsAttended(List<AttendedEvent> eventsAttended) {
    eventsAttended.forEach((element) {
      element.members
          .removeWhere((member) => member.id == ProfileService.userId!);
    });
    _eventsAttended = eventsAttended;
    notifyListeners();
  }

  setAdmirers(List<User> admirers) {
    _admirers = admirers;
    notifyListeners();
  }

  setOwnEvent(int eventId, double average) {
    var index =
        _myOwnEvents.indexWhere((element) => element.event.id == eventId);
    _myOwnEvents[index].ratingAverage = average;

    notifyListeners();
  }

  addOwnEvent(EventAndRatingAverage event) {
    _myOwnEvents.add(event);
    notifyListeners();
  }

  updateOwnEvents(EventReview ownEvent) {
    (myOwnEvents
            .map((item) => item.event.id)
            .contains(ownEvent.reviewedEvent.event.id))
        ? setOwnEvent(ownEvent.reviewedEvent.event.id,
            ownEvent.reviewedEvent.ratingAverage)
        : addOwnEvent(EventAndRatingAverage(
            ownEvent.reviewedEvent.event,
            ownEvent.reviewedEvent.ratingAverage,
            ownEvent.reviewedEvent.members));

    notifyListeners();
  }

  setOwnEvents(List<EventAndRatingAverage> ownEvents) {
    ownEvents.forEach((element) {
      element.members
          .removeWhere((member) => member.id == ProfileService.userId!);
    });
    _myOwnEvents = ownEvents;
    notifyListeners();
  }

  setFriendRequestSent(bool friendRequestSent) {
    _friendRequestSent = friendRequestSent;
    notifyListeners();
  }

  setUser(User user) {
    _user = user;
    notifyListeners();
  }

  setIsFriend(bool isFriend) {
    _isFriend = isFriend;
    notifyListeners();
  }

  setProfileImage(List<int> profileImage) {
    _user!.profileImage = profileImage;

    notifyListeners();
  }

  Future<GetUserProfileResponse?> initialize(int userId) async {
    setProcessing(true);

    //connect to SignalR Server:
    // await _chatHub.connect();

    var response = await provider
        .get<IAuthService>()
        .getUserProfileResponse(ProfileService.userId!, userId);

    setUser(response!.user);
    setIsFriend(response.isFriend);
    setEventsAttended(response.eventsAttended);
    setAdmirers(response.admirers);
    setOwnEvents(response.myOwnEvents);
    setHonors(response.honors);
    setGivenHonors(response.givenHonors);
    setAttendedCategoriesWithHonors(response.attendedCategories);
    setFriendRequestSent(response.friendRequestSent);

    setProcessing(false);

    return response;
  }

  Future<UploadProfileImageResponse?> changeProfileImage(
      File file, int userId) async {
    var response =
        await provider.get<IAuthService>().saveProfileImage(file, userId);

    setProfileImage(response!.profileImage);

    // await Future.delayed(const Duration(seconds: 5));
    return response;
  }

  Future sendFriendRequest(int fromUserId, int toUserId) async {
    setFriendRequestSent(true);

    await _chatHub.sendFriendRequest(fromUserId, toUserId);
  }

  onAcceptedFriendRequest(String content, int newNumberOfFriends,
      int friendRequestId, String newFriendContent) {
    setIsFriend(true);
  }

  onReceivedEventReview(String content) {
    var reviewedEventInfo = EventReview.fromJson(jsonDecode(content));

    updateOwnEvents(reviewedEventInfo);
  }

  onReceivedHonor(String content) {
    var memberHonorInfo = MembersHonor.fromJson(jsonDecode(content));

    updateAdmirers(memberHonorInfo.fromHonor);
    updateAttendedCategories(memberHonorInfo.attendedCategory);
  }
}
