import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:social_app/Models/attended_category.dart';
import 'package:social_app/Models/group_image_transport.dart';
import 'package:social_app/services/chat/chat_hub/chat_hub.dart';
import 'package:social_app/services/ichat_service.dart';
import 'package:social_app/services/profile_service.dart';

import '../Models/add_user_to_chat_group_model.dart';
import '../Models/chat_group_leaving_model.dart';
import '../Models/group.dart';
import '../Models/user.dart';
import '../utilities/service_locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConversationDetailsViewModel extends ChangeNotifier {
  List<User> _members = [];
  List<User> _friends = [];
  bool _isGroup = false;
  bool _processing = false;
  bool _groupNameEditisEmpty = true;
  String _conversationDetailName = "";
  List<int>? _conversationDetailImage;
  late int _conversationId;
  List<AttendedCategory>? _commonAttendedCategories = [];
  List<Group>? _commonGroups = [];
  late BuildContext _context;

  final ChatHub _chatHub = provider.get<ChatHub>();

  List<User> get members => _members;
  List<User> get friends => _friends;
  bool get isGroup => _isGroup;
  bool get processing => _processing;
  bool get groupNameEditisEmpty => _groupNameEditisEmpty;
  String get groupName => _conversationDetailName;
  List<int>? get conversationDetailImage => _conversationDetailImage;
  String get conversationDetailName => _conversationDetailName;
  int get conversationId => _conversationId;
  List<AttendedCategory>? get commonAttendedCategories =>
      _commonAttendedCategories;
  List<Group>? get commonGroups => _commonGroups;

  ConversationDetailsViewModel() {
    _chatHub.addUpdatedGroupNameHandler(
        "ConversationDetailsViewModelUpdatedGroupNameHandler",
        (groupId, newGroupName) => onUpdatedGroupName(groupId, newGroupName));

    _chatHub.addUpdatedGroupImageHandler(
        "ConversationDetailsViewModelUpdatedGroupImageHandler",
        (content) => onUpdatedGroupImage(content));

    _chatHub.addLeftChatGroupHandler(
        "ConversationDetailsViewModelMemberLeftChatGroupHandler",
        (content) => onMemberLeftChatGroup(content));

    _chatHub.addAddedMembersToChatGroupHandler(
        "ConversationDetailsViewModelAddedMembersToChatGroupHandler",
        (content) => onAddedMembersToChatGroup(content));

    _chatHub.addCreatedNewConversationWithFriend(
        "ConversationDetailsViewModelCreatedNewConversationWithFriendHandler",
        (content, newNumberOfFriends, friendRequestId, newFriendContent) =>
            onCreatedNewConversationWithFriend(content, newNumberOfFriends,
                friendRequestId, newFriendContent));
  }

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  List<User> getFriendsWhichAreNotInGroup() {
    List<User> result = [];
    for (var element in friends) {
      if (!members.map((e) => e.id).contains(element.id)) {
        result.add(element);
      }
    }

    return result;
  }

  setConversationId(int conversationId) {
    _conversationId = conversationId;
    notifyListeners();
  }

  setGroupNameEditisEmpty(bool groupNameEditisEmpty) {
    _groupNameEditisEmpty = groupNameEditisEmpty;
    notifyListeners();
  }

  setCommonAttendedCategories(List<AttendedCategory> commonAttendedCategories) {
    _commonAttendedCategories = commonAttendedCategories;
    notifyListeners();
  }

  setCommonGroups(List<Group> commonGroups) {
    _commonGroups = commonGroups;
    notifyListeners();
  }

  setIsGroup(bool isGroup) {
    _isGroup = isGroup;

    notifyListeners();
  }

  setMembers(List<User> members) {
    _members = members;
    notifyListeners();
  }

  setFriends(List<User> friends) {
    _friends = friends;
    notifyListeners();
  }

  addFriend(User newFriend) {
    _friends.add(newFriend);
    notifyListeners();
  }

  setGroupName(String groupName) {
    _conversationDetailName = groupName;
    notifyListeners();
  }

  setConversationDetailImage(List<int>? conversationDetailImage) {
    _conversationDetailImage = conversationDetailImage;
    notifyListeners();
  }

  setConversationDetailName(String conversationDetailName) {
    _conversationDetailName = conversationDetailName;
    notifyListeners();
  }

  processNewGroupName(String groupName) {
    String newGroupName = groupName;

    var names = newGroupName.split(',');
    names.remove(ProfileService.firstname);
    names.insert(0, AppLocalizations.of(_context)!.chat_list_view_you_text);

    newGroupName = names.join(',');
    setConversationDetailName(newGroupName);
  }

  removeGroupPartner(int partnerId) {
    _members.removeWhere((element) => element.id == partnerId);
    notifyListeners();
  }

  Future initialize(
      bool isGroup,
      List<User> members,
      String conversationDetailName,
      List<int>? conversationDetailImage,
      int conversationId,
      List<User> friends,
      BuildContext context) async {
    _context = context;
    setFriends(friends);
    setProcessing(true);

    //connect to SignalR Server:
    await _chatHub.connect();

    setConversationId(conversationId);
    setIsGroup(isGroup);
    setMembers(members);
    setGroupName(groupName);
    setConversationDetailName(conversationDetailName);
    setConversationDetailImage(conversationDetailImage);

    if (!isGroup) {
      var response = await provider<IChatService>()
          .getCommonStuff(ProfileService.userId!, members.first.id!);

      setCommonAttendedCategories(response!.commonAttendedCategories);
      setCommonGroups(response.commonGroups);
    }

    setProcessing(false);
  }

  Future updateGroupName(String newGroupName) async {
    await provider
        .get<ChatHub>()
        .updateGroupName(conversationId, newGroupName, ProfileService.userId!);
  }

  Future updateGroupImage(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 150,
      minHeight: 150,
      quality: 60,
    );

    // print(file.lengthSync());
    // print(result!.length);

    //now get bytes as List<int>
    var bytes = result!.toList();

    await provider
        .get<ChatHub>()
        .updateGroupImage(conversationId, bytes, ProfileService.userId!);
  }

  leaveGroup(BuildContext context) async {
    await provider
        .get<ChatHub>()
        .leaveChatGroup(conversationId, ProfileService.userId!);

    await Future.delayed(const Duration(seconds: 3));

    int count = 0;
    // ignore: use_build_context_synchronously
    Navigator.of(context).popUntil((_) => count++ >= 3);
  }

  onUpdatedGroupName(int groupId, String newGroupName) {
    if (groupId == conversationId) {
      setGroupName(newGroupName);
    }
  }

  onUpdatedGroupImage(String content) {
    var groupImageObject = GroupImageTransport.fromJson(jsonDecode(content));

    if (groupImageObject.groupId == conversationId) {
      setConversationDetailImage(groupImageObject.groupImage);
    }
  }

  onMemberLeftChatGroup(String content) {
    var info = ChatGroupLeavingModel.fromJson(jsonDecode(content));
    int groupId = info.conversationId;
    int userId = info.userId;
    String groupName = info.newGroupName;

    if (conversationId != groupId) return;

    if (ProfileService.userId! != userId) {
      removeGroupPartner(userId);
      if (groupName.contains(',')) {
        processNewGroupName(groupName);
      }
    }
  }

  onAddedMembersToChatGroup(String content) {
    var info = AddUserToChatGroupModel.fromJson(jsonDecode(content));
    var newMemberList = info.newGroupPartnerList;
    var chatListItem = info.chatListItem;

    if (chatListItem.conversationId != conversationId) return;

    setMembers(newMemberList);
    if (chatListItem.conversationDescription!.contains(',')) {
      processNewGroupName(chatListItem.conversationDescription!);
    }
  }

  onCreatedNewConversationWithFriend(String content, int newNumberOfFriends,
      int friendRequestId, String newFriendContent) {
    var newFriend = User.fromJson(jsonDecode(newFriendContent));
    addFriend(newFriend);
  }

  @override
  void dispose() {
    _chatHub.removeUpdatedGroupNameHandler(
        "ConversationDetailsViewModelUpdatedGroupNameHandler");

    _chatHub.removeUpdatedGroupImageHandler(
        "ConversationDetailsViewModelUpdatedGroupImageHandler");

    _chatHub.removeLeftChatGroupHandler(
        "ConversationDetailsViewModelMemberLeftChatGroupHandler");

    _chatHub.removeAddedMembersToChatGroupHandler(
        "ConversationDetailsViewModelAddedMembersToChatGroupHandler");

    _chatHub.removeAcceptedFriendRequestHandler(
        "ConversationDetailsViewModelCreatedNewConversationWithFriendHandler");

    super.dispose();
  }
}
