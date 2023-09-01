import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_app/Models/friend_request.dart';
import 'package:social_app/Models/user.dart';
import 'package:social_app/services/chat/chat_hub/chat_hub.dart';
import 'package:social_app/services/chat/get_friend_requests_response.dart';
import 'package:social_app/services/chat/received_friend_request_model.dart';
import 'package:social_app/services/ichat_service.dart';
import 'package:social_app/services/profile_service.dart';

import '../utilities/service_locator/locator.dart';

class FriendRequestsViewModel extends ChangeNotifier {
  List<FriendRequest> _friendRequests = [];
  int? _numberOfFriends;
  bool _processing = false;

  List<FriendRequest> get friendsRequests => _friendRequests;
  int? get numberOfFriends => _numberOfFriends;
  bool get processing => _processing;

  final ChatHub _chatHub = provider.get<ChatHub>();

  FriendRequestsViewModel() {
    _chatHub.addCreatedNewConversationWithFriend(
        "FriendRequestsViewModelCreatedNewConversationWithFriendHandler",
        (content, newNumberOfFriends, friendRequestId, newFriendContent) =>
            onAcceptedFriendRequest(content, newNumberOfFriends,
                friendRequestId, newFriendContent));

    _chatHub.addReceivedFriendRequestHandler(
        "FriendRequestViewModelReceivedFriendRequest",
        (content) => onReceivedFriendRequest(content));
  }

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  setFriendRequests(List<FriendRequest> friendRequests) {
    _friendRequests = friendRequests;
    notifyListeners();
  }

  setNumberOfFriends(int numberOfFriends) {
    _numberOfFriends = numberOfFriends;
    notifyListeners();
  }

  acceptFriendRequestUI(int index) {
    _friendRequests[index].accepted = true;
    notifyListeners();
  }

  incrementNumberOfFriends() {
    int newNumber = _numberOfFriends! + 1;
    _numberOfFriends = newNumber;

    notifyListeners();
  }

  addFriendRequest(FriendRequest friendRequest) {
    _friendRequests.add(friendRequest);
    notifyListeners();
  }

  removeFriendRequest(int fromUserId) {
    _friendRequests.removeWhere((element) => element.user.id == fromUserId);
    notifyListeners();
  }

  Future<GetFriendRequestsResponse?> initialize() async {
    setProcessing(true);

    //connect to SignalR Server:
    await _chatHub.connect();

    var response = await provider
        .get<IChatService>()
        .getFriendRequests(ProfileService.userId!);

    setFriendRequests(response!.friendRequests);
    setNumberOfFriends(response.numberOfFriends);

    setProcessing(false);

    return response;
  }

  onAcceptedFriendRequest(String content, int newNumberOfFriends,
      int friendRequestId, String newFriendContent) {
    setNumberOfFriends(newNumberOfFriends);

    acceptFriendRequestUI(_friendRequests
        .indexWhere((element) => element.friendRequestId == friendRequestId));
  }

  onReceivedFriendRequest(String content) {
    
    var friendRequestInfo =
        ReceivedFriendRequestModel.fromJson(jsonDecode(content));

    var fromUser = User(friendRequestInfo.id, "", friendRequestInfo.firstname, friendRequestInfo.lastname, friendRequestInfo.profileImage);

    addFriendRequest(FriendRequest(fromUser, friendRequestInfo.friendRequestId, false));
  }

  Future acceptFriendRequest(int friendRequestId, int fromId, int toId) async {
    acceptFriendRequestUI(_friendRequests
        .indexWhere((element) => element.friendRequestId == friendRequestId));
    await _chatHub.acceptFriendRequest(friendRequestId, fromId, toId);
    //incrementNumberOfFriends();
  }
}
