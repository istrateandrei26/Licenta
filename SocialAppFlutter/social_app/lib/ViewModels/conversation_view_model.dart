import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:social_app/Models/chat_group_leaving_model.dart';
import 'package:social_app/Models/message_reaction.dart';
import 'package:social_app/Models/user.dart';
import 'package:social_app/services/chat/retrieve_messages_response.dart';
import 'package:social_app/services/ichat_service.dart';
import 'package:social_app/services/profile_service.dart';

import '../Models/add_user_to_chat_group_model.dart';
import '../Models/group_image_transport.dart';
import '../Models/remove_message_reaction.dart';
import '../Models/message.dart';
import '../services/chat/chat_hub/chat_hub.dart';
import '../utilities/service_locator/locator.dart';

class ConversationViewModel extends ChangeNotifier {
  List<User> _friends = [];
  List<Message> _messages = [];
  bool _processing = false;
  late int _fromUserId;
  int _userId = ProfileService.userId!;
  late int _conversationId;
  List<User> _conversationPartners = [];
  String? _groupName;
  List<int>? _groupImage;
  bool _isGroup = false;
  TextEditingController messageTextController = TextEditingController();
  TextEditingController changeGroupNameController = TextEditingController();

  final ChatHub _chatHub = provider.get<ChatHub>();

  List<User> get friends => _friends;
  List<Message> get messages => _messages;
  int get fromUserId => _fromUserId;
  int get userId => _userId;
  int get conversationId => _conversationId;
  List<User> get conversationPartners => _conversationPartners;
  bool get processing => _processing;
  String? get groupName => _groupName;
  List<int>? get groupImage => _groupImage;
  bool get isGroup => _isGroup;
  String get messageText => messageTextController.text;

  ConversationViewModel() {
    _chatHub.addReceivedChatMessageHandler(
        "ConversationViewModelReceivedMessageHandler",
        (fromId, isImage, isVideo, content, fromUserDetailsInfo, messageId) =>
            onReceivedMessage(fromId, isImage, isVideo, content, fromUserDetailsInfo, messageId));

    _chatHub.addUpdatedGroupNameHandler(
        "ConversationViewModelUpdatedGroupNameHandler",
        (groupId, newGroupName) => onUpdatedGroupName(groupId, newGroupName));

    _chatHub.addUpdatedGroupImageHandler(
        "ConversationViewModelUpdatedGroupImageHandler",
        (content) => onUpdatedGroupImage(content));

    _chatHub.addLeftChatGroupHandler(
        "ConversationViewModelMemberLeftChatGroupHandler",
        (content) => onMemberLeftChatGroup(content));

    _chatHub.addAddedMembersToChatGroupHandler(
        "ConversationViewModelAddedMembersToChatGroupHandler",
        (content) => onAddedMembersToChatGroup(content));

    _chatHub.addReceivedMessageReactionHandler(
        "ConversationViewModelReceivedMessageReaction",
        (content) => onReceivedMessageReaction(content));

    _chatHub.addRemovedMessageReactionHandler(
        "ConversationViewModelRemovedMessageReaction",
        (content) => onRemovedMessageReaction(content));

    _chatHub.addCreatedNewConversationWithFriend(
        "ConversationViewModelCreatedNewConversationWithFriendHandler",
        (content, newNumberOfFriends, friendRequestId, newFriendContent) =>
            onCreatedNewConversationWithFriend(content, newNumberOfFriends,
                friendRequestId, newFriendContent));
  }

  bool messageHasReactions(Message message) {
    return message.usersWhoReacted.isNotEmpty;
  }

  bool messageIsFromMyself(Message message) {
    return ProfileService.userId! == message.fromUser;
  }

  bool iAlreadyReactedOnMessage(Message message) {
    return message.usersWhoReacted
        .any((element) => element.id == ProfileService.userId);
  }

  setProcessing(bool processing) async {
    _processing = processing;
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

  setIsGroup(bool isGroup) {
    _isGroup = isGroup;

    notifyListeners();
  }

  setMessages(List<Message> messages) {
    _messages = messages;
    notifyListeners();
  }

  addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  setFromUserId(int fromUserId) {
    _fromUserId = fromUserId;
    notifyListeners();
  }

  setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  setConversationId(int conversationId) {
    _conversationId = conversationId;
    notifyListeners();
  }

  setConversationPartners(List<User> conversationPartners) {
    _conversationPartners = conversationPartners;
    notifyListeners();
  }

  setGroupName(String groupName) {
    if (isGroup && groupName.contains(',')) {
      // replace my name with string "You"
      var names = groupName.split(',');
      names.remove(ProfileService.firstname);
      names.insert(0, "You");

      //rebuild description
      _groupName = names.join(',');
    } else {
      _groupName = groupName;
    }

    notifyListeners();
  }

  setGroupImage(List<int>? groupImage) {
    _groupImage = groupImage;
    notifyListeners();
  }

  removeConversationPartner(int partnerId) {
    _conversationPartners.removeWhere((element) => element.id == partnerId);
    notifyListeners();
  }

  addMessageReaction(int messageId, User whoReacted) {
    _messages
        .firstWhere((element) => element.id == messageId)
        .usersWhoReacted
        .add(whoReacted);

    notifyListeners();
  }

  removeMessageReaction(int messageId, int whoRemovedReaction) {
    _messages
        .firstWhere((element) => element.id == messageId)
        .usersWhoReacted
        .removeWhere((element) => element.id == whoRemovedReaction);

    notifyListeners();
  }

  Future<RetrieveMessagesResponse?> initialize(
      int conversationId) async {
    setConversationId(conversationId);

    setProcessing(true);
    //connect to SignalR Server:
    await _chatHub.connect();
    //retrieve messages from Chat Service:
    var response =
        await provider.get<IChatService>().getMessages(userId, conversationId);

    setMessages(response!.messages);
    setIsGroup(response.isGroup);
    setConversationPartners(response.conversationPartners);
    setGroupImage(response.groupImage);
    setGroupName(response.groupName);
    setFriends(response.friends);

    setProcessing(false);

    return response;
  }

  void reactToMessage(int messageId) {
    provider.get<ChatHub>().reactToMessage(userId, messageId, conversationId);
  }

  void removeReactionFromMessage(int messageId) {
    provider
        .get<ChatHub>()
        .removeReactionFromMessage(userId, messageId, conversationId);
  }

  Future updateGroupName(String newGroupName) async {
    await provider
        .get<ChatHub>()
        .updateGroupName(conversationId, newGroupName, ProfileService.userId!);
  }

  Future sendTextMessage() async {
    if (messageText.trim() != "") {
      await provider.get<ChatHub>().sendMessageToConversation(
          userId, -1, conversationId, messageText, 0, 0);

      // addMessage(Message(
      //     fromUser: userId,
      //     toUser: conversationPartners.first.id,
      //     content: messageText,
      //     datetime: DateTime.now(),
      //     conversationId: conversationId,
      //     isImage: false,
      //     isVideo: false,
      //     fromUserDetails: User(ProfileService.userId, ProfileService.email, ProfileService.firstname, ProfileService.lastname, ProfileService.profileImage),
      //     usersWhoReacted: []));

      messageTextController.clear();
    }
  }

  Future sendFileMessage(String downloadUrl, int isImage, int isVideo) async {
    bool image = isImage == 1 ? true : false;
    bool video = isVideo == 1 ? true : false;

    await provider.get<ChatHub>().sendMessageToConversation(
        userId, -1, conversationId, downloadUrl, isImage, isVideo);

    // addMessage(Message(
    //     fromUser: userId,
    //     toUser: null,
    //     content: downloadUrl,
    //     datetime: DateTime.now(),
    //     conversationId: conversationId,
    //     isImage: image,
    //     isVideo: video,
    //     fromUserDetails: User(ProfileService.userId, ProfileService.email, ProfileService.firstname, ProfileService.lastname, ProfileService.profileImage),
    //     usersWhoReacted: []));
  }

  onUpdatedGroupName(int groupId, String newGroupName) {
    setGroupName(newGroupName);
  }

  onUpdatedGroupImage(String content) {
    var groupImageObject = GroupImageTransport.fromJson(jsonDecode(content));

    if (groupImageObject.groupId == conversationId) {
      setGroupImage(groupImageObject.groupImage);
    }
  }

  onMemberLeftChatGroup(String content) {
    var info = ChatGroupLeavingModel.fromJson(jsonDecode(content));
    var userId = info.userId;
    var groupId = info.conversationId;
    var newGroupName = info.newGroupName;

    if (ProfileService.userId! != userId && groupId == conversationId) {
      removeConversationPartner(userId);

      if (newGroupName.contains(',')) {
        setGroupName(newGroupName);
      }
    }
  }

  onAddedMembersToChatGroup(String content) {
    var info = AddUserToChatGroupModel.fromJson(jsonDecode(content));
    var newMemberList = info.newGroupPartnerList;
    var chatListItem = info.chatListItem;
    // var addedUsers = info.addedUsers;

    if (chatListItem.conversationId != conversationId) return;

    setConversationPartners(newMemberList);
    setGroupName(chatListItem.conversationDescription!);
  }

  onReceivedMessage(int fromId, int isImage, int isVideo, String content, String fromUserDetailsInfo, int messageId) {
    bool image = isImage == 1 ? true : false;
    bool video = isVideo == 1 ? true : false;


    addMessage(Message(
        id: messageId,
        fromUser: fromId,
        toUser: userId,
        content: content,
        datetime: DateTime.now(),
        conversationId: conversationId,
        isImage: image,
        isVideo: video,
        fromUserDetails: User.fromJson(jsonDecode(fromUserDetailsInfo)),
        usersWhoReacted: []));
  }

  onReceivedMessageReaction(String content) {
    var info = MessageReaction.fromJson(jsonDecode(content));
    var conversationId = info.conversationId;
    var messageId = info.reactedMessageId;
    var whoReacted = info.whoReacted;

    if (_conversationId != conversationId) return;

    addMessageReaction(messageId, whoReacted);
  }

  onRemovedMessageReaction(String content) {
    var info = RemoveMessageReaction.fromJson(jsonDecode(content));

    var conversationId = info.conversationId;
    var messageId = info.messageId;
    var whoRemovedReaction = info.whoRemovedReaction;

    if (_conversationId != conversationId) return;

    removeMessageReaction(messageId, whoRemovedReaction);
  }

  onCreatedNewConversationWithFriend(String content, int newNumberOfFriends,
      int friendRequestId, String newFriendContent) {
    var newFriend = User.fromJson(jsonDecode(newFriendContent));
    addFriend(newFriend);
  }

  @override
  void dispose() {
    _chatHub.removeReceivedChatMessageHandler(
        "ConversationViewModelReceivedMessageHandler");

    _chatHub.removeUpdatedGroupNameHandler(
        "ConversationViewModelUpdatedGroupNameHandler");

    _chatHub.removeUpdatedGroupImageHandler(
        "ConversationViewModelUpdatedGroupImageHandler");

    _chatHub.removeLeftChatGroupHandler(
        "ConversationViewModelMemberLeftChatGroupHandler");

    _chatHub.removeAddedMembersToChatGroupHandler(
        "ConversationViewModelAddedMembersToChatGroupHandler");

    _chatHub.removeRemovedMessageReactionHandler(
        "ConversationViewModelRemovedMessageReaction");

    _chatHub.removeAcceptedFriendRequestHandler(
        "ConversationViewModelCreatedNewConversationWithFriendHandler");

    super.dispose();
  }
}
