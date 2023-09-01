import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/event_review_info.dart';

import '../Models/user.dart';
import '../services/events/event_hub/event_hub.dart';
import '../services/profile_service.dart';
import '../utilities/service_locator/locator.dart';

class ReviewViewModel extends ChangeNotifier {
  late EventReviewInfo _eventReviewInfo;
  HashSet<String> _selectedUsers = HashSet();
  HashSet<int> _selectedUsersIds = HashSet();
  double _ratingScore = 1;

  Event get eventInfo => _eventReviewInfo.event;
  List<User> get eventMembers => _eventReviewInfo.members.where((element) => element.id != ProfileService.userId).toList();
  HashSet<String> get selectedUsers => _selectedUsers;
  HashSet<int> get selectedUsersIds => _selectedUsersIds;
  double get ratingScore => _ratingScore;

  late EventHub _eventHub;

  setEventReviewInfo(EventReviewInfo eventReviewInfo) {
    _eventReviewInfo = eventReviewInfo;
  }

  setSelectedUsers(HashSet<String> selectedUsers) {
    _selectedUsers = selectedUsers;
    notifyListeners();
  }

  setSelectedUsersIds(HashSet<int> selectedUsersIds) {
    _selectedUsersIds = selectedUsersIds;
    notifyListeners();
  }

  setRatingScore(double ratingScore) {
    _ratingScore = ratingScore;
    notifyListeners();
  }

  ReviewViewModel({required EventReviewInfo eventReviewInfo}) {
    setEventReviewInfo(eventReviewInfo);
  }

  Future initialize() async {
    _eventHub = provider.get<EventHub>();
    _eventHub.connect();
  }

  Future sendReview() async {
    if (selectedUsersIds.isEmpty) {
      await _eventHub.reviewOnlyEvent(eventInfo.id, ratingScore.toInt(), ProfileService.userId!);
    } else {
      await _eventHub.honorMembers(
          selectedUsersIds.toList(), eventInfo.id, ProfileService.userId!);

      await _eventHub.reviewOnlyEvent(eventInfo.id, ratingScore.toInt(), ProfileService.userId!);
    }
  }
}
