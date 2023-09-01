import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:social_app/Models/add_user_to_chat_group_model.dart';
import 'package:social_app/Models/chat_group_leaving_model.dart';
import 'package:social_app/Models/last_message.dart';
import 'package:social_app/Models/user.dart';
import 'package:social_app/services/ichat_service.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/service_locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Models/group_image_transport.dart';
import '../services/chat/chat_hub/chat_hub.dart';
import '../services/chat/retrieve_chatlist_response.dart';

class ChatListViewModel extends ChangeNotifier {
  List<User> _friends = [];
  List<LastMessage> _lastMessages = [];
  List<User> _recommendedPersons = [];
  User _userDetails = User(ProfileService.userId, null, null, null, null);
  bool _processing = false;
  late BuildContext _context;

  List<User> get friends => _friends;
  List<LastMessage> get lastMessages => _lastMessages;
  List<User> get recommendedPersons => _recommendedPersons;
  User get userDetails => _userDetails;
  bool get processing => _processing;

  final ChatHub _chatHub = provider.get<ChatHub>();

  ChatListViewModel() {
    _chatHub.addReceivedChatListMessageHandler(
        "ChatListViewModelReceivedMessageHandler",
        (content) => onReceivedMessage(content));

    _chatHub.addCreatedNewConversationWithFriend(
        "ChatListViewModelCreatedNewConversationWithFriendHandler",
        (content, newNumberOfFriends, friendRequestId, newFriendContent) =>
            onCreatedNewConversationWithFriend(content, newNumberOfFriends,
                friendRequestId, newFriendContent));

    _chatHub.addCreatedGroupHandler("ChatListViewModelCreatedGroupHandler",
        (content) => onCreatedNewGroup(content));

    _chatHub.addUpdatedGroupNameHandler(
        "ChatListViewModelUpdatedGroupNameHandler",
        (groupId, newGroupName) => onUpdatedGroupName(groupId, newGroupName));

    _chatHub.addUpdatedGroupImageHandler(
        "ChatListViewModelUpdatedGroupImageHandler",
        (content) => onUpdatedGroupImage(content));

    _chatHub.addLeftChatGroupHandler(
        "ChatListViewModelMemberLeftChatGroupHandler",
        (content) => onMemberLeftChatGroup(content));

    _chatHub.addAddedMembersToChatGroupHandler(
        "ChatListViewModelAddedMembersToChatGroupHandler",
        (content) => onAddedMembersToChatGroup(content));
  }

  String? processConversationDescription(LastMessage lastMessage) {
    // check if conversation has more than 2 members
    if (lastMessage.isGroup &&
        lastMessage.conversationDescription!.contains(',')) {
      String description = lastMessage.conversationDescription!;

      // replace my name with string "You"
      var names = description.split(',');
      names.remove(ProfileService.firstname);
      names.insert(0, AppLocalizations.of(_context)!.chat_list_view_you_text);

      // rebuild description
      description = names.join(',');

      return description;
    }

    return null;
  }

  deleteNewFriendFromRecommendedFriends(int newFriendId) async {
    bool foundUser =
        recommendedPersons.any((element) => element.id == newFriendId);

    if (foundUser) {
      recommendedPersons.removeWhere((element) => element.id == newFriendId);
    }
    notifyListeners();
  }

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  setFriends(List<User> friends) {
    _friends = friends;
    notifyListeners();
  }

  setRecommendedPersons(List<User> recommendedPersons) {
    _recommendedPersons = recommendedPersons;
    notifyListeners();
  }

  addFriend(User newFriend) {
    _friends.add(newFriend);
    notifyListeners();
  }

  setLastMessages(List<LastMessage> lastMessages) {
    lastMessages.forEach((element) {
      var description = processConversationDescription(element);
      if (description != null) {
        element.conversationDescription = description;
      }
    });
    _lastMessages = lastMessages;
    notifyListeners();
  }

  removeLastMessage(int conversationId) {
    _lastMessages
        .removeWhere((element) => element.conversationId == conversationId);

    notifyListeners();
  }

  removePartnerFromConversation(int conversationId, int partnerId) {
    _lastMessages
        .firstWhere((element) => element.id == conversationId)
        .userDetails
        .removeWhere((element) => element.id == partnerId);

    notifyListeners();
  }

  addLastMessage(LastMessage message) {
    var description = processConversationDescription(message);
    if (description != null) message.conversationDescription = description;

    _lastMessages.insert(0, message);
    notifyListeners();
  }

  setUserDetails(User userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }

  processNewGroupName(String groupName, int groupId) {
    String newGroupName = groupName;

    var names = newGroupName.split(',');
    names.remove(ProfileService.firstname);
    names.insert(0, AppLocalizations.of(_context)!.chat_list_view_you_text);

    newGroupName = names.join(',');
    _lastMessages
        .firstWhere((element) => element.conversationId == groupId)
        .conversationDescription = newGroupName;

    notifyListeners();
  }

  removePartnerFromChatListItem(int partnerId, int groupId) {
    _lastMessages
        .firstWhere((element) => element.conversationId == groupId)
        .userDetails
        .removeWhere((element) => element.id == partnerId);

    notifyListeners();
  }

  setMembersOfChatListItem(int groupId, List<User> newPartnersList) {
    if (!_lastMessages.any((element) => element.conversationId == groupId)) {
      return;
    }

    _lastMessages
        .firstWhere((element) => element.conversationId == groupId)
        .userDetails = newPartnersList;

    notifyListeners();
  }

  Future<RetrieveChatListResponse?> initialize(BuildContext context) async {
    var userId = userDetails.id;
    _context = context;

    setProcessing(true);

    await _chatHub.connect();

    var response =
        await provider.get<IChatService>().getChatList(ProfileService.userId!);

    setFriends(response!.friends);
    setLastMessages(response.lastMessages);
    setUserDetails(response.user);
    setRecommendedPersons(response.recommendedPersons);

    setProcessing(false);

    return response;
  }

  onCreatedNewConversationWithFriend(String content, int newNumberOfFriends,
      int friendRequestId, String newFriendContent) {
    var newFriend = User.fromJson(jsonDecode(newFriendContent));
    addFriend(newFriend);

    deleteNewFriendFromRecommendedFriends(newFriend.id!);

    var lastMessage = LastMessage.fromJson(jsonDecode(content));
    addLastMessage(lastMessage);
  }

  onUpdatedGroupName(int groupId, String newGroupName) {
    _lastMessages
        .firstWhere((element) => element.conversationId == groupId)
        .conversationDescription = newGroupName;

    notifyListeners();
  }

  onUpdatedGroupImage(String content) {
    var groupImageObject = GroupImageTransport.fromJson(jsonDecode(content));

    _lastMessages
        .firstWhere(
            (element) => element.conversationId == groupImageObject.groupId)
        .groupImage = groupImageObject.groupImage;

    notifyListeners();
  }

  onCreatedNewGroup(String content) {
    var lastMessage = LastMessage.fromJson(jsonDecode(content));

    addLastMessage(lastMessage);
  }

  onMemberLeftChatGroup(String content) {
    var info = ChatGroupLeavingModel.fromJson(jsonDecode(content));

    int groupId = info.conversationId;
    int userId = info.userId;
    String groupName = info.newGroupName;

    if (userId == ProfileService.userId!) {
      removeLastMessage(groupId);
    } else {
      // remove partner from chat list item
      removePartnerFromChatListItem(userId, groupId);
      // process name if contained users' firstnames enumerated and separated by comma
      if (groupName.contains(',')) {
        processNewGroupName(groupName, groupId);
      }
    }
  }

  onAddedMembersToChatGroup(String content) {
    var info = AddUserToChatGroupModel.fromJson(jsonDecode(content));
    var newPartnersList = info.newGroupPartnerList;
    var chatListItem = info.chatListItem;
    var addedUsers = info.addedUsers;

    if (!addedUsers.any((element) => element.id == ProfileService.userId)) {
      setMembersOfChatListItem(chatListItem.conversationId, newPartnersList);
      if (chatListItem.conversationDescription!.contains(',')) {
        processNewGroupName(
            chatListItem.conversationDescription!, chatListItem.conversationId);
      }
    } else {
      addLastMessage(chatListItem);
    }
  }

  onReceivedMessage(String content) {
    var message = LastMessage.fromJson(jsonDecode(content));

    var lastMessageInfo = _lastMessages
        .firstWhere(
            (element) => element.conversationId == message.conversationId)
        .userDetails
        .first;

    removeLastMessage(message.conversationId);

    var userFrom = User(
        lastMessageInfo.id,
        lastMessageInfo.email,
        lastMessageInfo.firstname,
        lastMessageInfo.lastname,
        lastMessageInfo.profileImage);

    addLastMessage(LastMessage(
        userDetails: message.userDetails,
        id: message.id,
        fromUser: message.fromUser,
        content: message.content,
        datetime: DateTime.now(),
        conversationId: message.conversationId,
        isImage: message.isImage,
        isVideo: message.isVideo,
        fromUserDetails: userFrom,
        conversationDescription: message.conversationDescription,
        groupImage: message.groupImage,
        isGroup: message.isGroup,
        usersWhoReacted: []));
  }
}
