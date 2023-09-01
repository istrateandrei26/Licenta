import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../Models/user.dart';
import '../services/chat/get_friends_response.dart';
import '../services/events/event_hub/event_hub.dart';
import '../services/profile_service.dart';
import '../utilities/service_locator/locator.dart';

class InviteFriendsToEventViewModel extends ChangeNotifier {
  HashSet<String> _selectedUsers = HashSet();
  HashSet<int> _selectedUsersIds = HashSet();
  List<User> _friendListOnSearch = [];
  List<User> _friendList = [];
  bool _processing = false;

  HashSet<String> get selectedUsers => _selectedUsers;
  HashSet<int> get selectedUsersIds => _selectedUsersIds;
  List<User> get friendListOnSearch => _friendListOnSearch;
  List<User> get friendList => _friendList;
  bool get processing => _processing;

  InviteFriendsToEventViewModel();

  setSelectedUsers(HashSet<String> selectedUsers) {
    _selectedUsers = selectedUsers;
    notifyListeners();
  }

  setFriendListOnSearch(List<User> friendListOnSearch) {
    _friendListOnSearch = friendListOnSearch;
    notifyListeners();
  }

  setFriendList(List<User> friendList) {
    _friendList = friendList;
    notifyListeners();
  }

  setProcessing(bool processing) {
    _processing = processing;
    notifyListeners();
  }

  Future<GetFriendsResponse?> initialize(List<User> friends) async {
    setProcessing(true);

    setFriendList(friends);

    setProcessing(false);

    return null;
  }

  inviteFriendsToEvent(int eventId) async {
    await provider.get<EventHub>().inviteFriendsToEvent(
        eventId, selectedUsersIds.toList(), ProfileService.userId!);

    await Future.delayed(const Duration(seconds: 2));
  }
}
