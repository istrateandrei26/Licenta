import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:social_app/Models/user.dart';
import 'package:social_app/services/chat/chat_hub/chat_hub.dart';
import 'package:social_app/services/chat/get_friends_response.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/service_locator/locator.dart';


class CreateGroupViewModel extends ChangeNotifier {
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

  // final ChatHub _chatHub = provider.get<ChatHub>();

  CreateGroupViewModel();

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
    var userId = ProfileService.userId;

    setProcessing(true);

    // await _chatHub.connect();

    // var response = await provider
    //     .get<IChatService>()
    //     .getFriends(ProfileService.userId!); //change!

    setFriendList(friends);

    setProcessing(false);
    
    return null;

    // return response;
  }

  Future createGroupConversation() async {
    selectedUsersIds.add(ProfileService.userId!);
    provider.get<ChatHub>().createGroupConversation(
        ProfileService.userId!, selectedUsersIds.toList());
  }
}
