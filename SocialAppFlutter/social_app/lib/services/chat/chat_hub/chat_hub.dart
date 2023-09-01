import 'dart:async';

import 'package:logging/logging.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/api_utility/api_manager.dart';
import 'package:social_app/utilities/logger/logger.dart';
import 'package:mutex/mutex.dart';

final chatHubMutex = Mutex();

class ChatHub {
  final String _serverUrl =
      "${ApiManager.chatServiceBaseUrl}/ChatHub?accessToken=${ProfileService.accessToken}";
  HubConnection? _hubConnection;
  Map<String, dynamic Function(int, int, int, String, String, int)>
      _onReceivedChatMessageHandler = Map();
  Map<String, dynamic Function(int)> _onAcceptedFriendRequestHandler = Map();
  Map<String, dynamic Function(String)>
      _onReceivedFriendRequestHandler = Map();

  Map<String, dynamic Function(String, int, int, String)>
      _onCreatedNewFriendConversationHandler = Map();

  Map<String, dynamic Function(String)> _onReceivedChatListMessageHandler =
      Map();

  Map<String, dynamic Function(String)> _onCreatedGroupHandler = Map();
  Map<String, dynamic Function(int, String)> _onUpdatedGroupNameHandler = Map();
  Map<String, dynamic Function(String)> _onUpdatedGroupImageHandler = Map();
  Map<String, dynamic Function(String)> _onMemberLeftChatGroup = Map();
  Map<String, dynamic Function(String)> _onAddedMembersToChatGroup = Map();
  Map<String, dynamic Function(String)> _onReceivedMessageReaction = Map();
  Map<String, dynamic Function(String)> _onRemovedMessageReaction = Map();

  bool _connectionIsOpen = false;

  ChatHub() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    final authorizeHeaderOption = MessageHeaders();
    authorizeHeaderOption.setHeaderValue(
        "ChatHubBearer", ProfileService.accessToken);

    _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl,
            options: HttpConnectionOptions(
                // requestTimeout: 500000,
                headers: authorizeHeaderOption,
                skipNegotiation: true,
                transport: HttpTransportType.WebSockets,
                logger: logger,
                logMessageContent: true))
        .configureLogging(logger)
        .withAutomaticReconnect(
            retryDelays: [2000, 5000, 10000, 20000]).build();

    _hubConnection?.onclose(({error}) {
      _connectionIsOpen = false;
    });

    _hubConnection?.onreconnecting(({error}) {
      print("[!] Chat client is reconnnecting...");
      _connectionIsOpen = false;
    });

    _hubConnection?.onreconnected(({connectionId}) {
      print("[+] Chat client successfully reconnected...");
      _connectionIsOpen = true;
    });

    //register handlers
    _hubConnection?.on("Received message", ((arguments) {
      onReceivedChatMessage(
          int.parse((arguments as List)[0].toString()),
          int.parse((arguments as List)[1].toString()),
          int.parse((arguments as List)[2].toString()),
          (arguments as List)[3].toString(),
          (arguments as List)[4].toString(),
          int.parse((arguments as List)[5].toString()));
      print(arguments);
    }));

    _hubConnection?.on("Accepted Friend Request", ((arguments) {
      onAcceptedFriendRequest(int.parse((arguments as List)[0].toString()));
      print(arguments);
    }));

    _hubConnection?.on("Received Friend Request", ((arguments) {
      onReceivedFriendRequest(
          (arguments as List)[0].toString()
);
      print(arguments);
    }));

    _hubConnection?.on("Received message in chat list", ((arguments) {
      onReceivedChatListMessage((arguments as List)[0].toString());
      print(arguments);
    }));

    _hubConnection?.on("Created Conversation With Friend", (arguments) {
      onCreatedNewConversationWithFriend(
          (arguments as List)[0].toString(),
          int.parse((arguments as List)[1].toString()),
          int.parse((arguments as List)[2].toString()),
          (arguments as List)[3].toString(),
        );
    });

    _hubConnection?.on("Created group", (arguments) {
      onCreatedGroup((arguments as List)[0].toString());
    });

    _hubConnection?.on("Updated Group Description", (arguments) {
      onUpdatedGroupName(int.parse((arguments as List)[0].toString()),
          (arguments as List)[1].toString());
    });

    _hubConnection?.on("Updated Group Image", (arguments) {
      onUpdatedGroupImage((arguments as List)[0].toString());
    });

    _hubConnection?.on("Member Left Chat Group", (arguments) {
      onMemmberLeftChatGroup((arguments as List)[0].toString());
    });

    _hubConnection?.on("Added Members To Chat Group", (arguments) {
      onAddedMembersToChatGroup((arguments as List)[0].toString());
    });

    _hubConnection?.on("User Reacted To Message", (arguments) {
      onReceivedMessageReaction((arguments as List)[0].toString());
    });

    _hubConnection?.on("User Removed Reaction To Message", (arguments) {
      onRemovedMessageReaction((arguments as List)[0].toString());
    });
  }

  Future connect() async {
    await chatHubMutex.acquire();

    if (_hubConnection?.state != HubConnectionState.Connected &&
        _connectionIsOpen == false) {
      await _hubConnection?.start();
      _connectionIsOpen = true;
    }

    chatHubMutex.release();
    return;
  }

  Future disconnect() async {
    await chatHubMutex.acquire();

    await _hubConnection?.stop();
    _connectionIsOpen = false;

    chatHubMutex.release();
  }

  void addRemovedMessageReactionHandler(
      String functionName, Function(String) handler) {
    _onRemovedMessageReaction[functionName] = handler;
  }

  void removeRemovedMessageReactionHandler(String callbackName) {
    _onRemovedMessageReaction.remove(callbackName);
  }

  void onRemovedMessageReaction(String content) {
    _onRemovedMessageReaction.forEach((key, value) {
      value(content);
    });
  }

  void addReceivedMessageReactionHandler(
      String functionName, Function(String) handler) {
    _onReceivedMessageReaction[functionName] = handler;
  }

  void removeReceivedMessageReactionHandler(String callbackName) {
    _onReceivedMessageReaction.remove(callbackName);
  }

  void onReceivedMessageReaction(String content) {
    _onReceivedMessageReaction.forEach((key, value) {
      value(content);
    });
  }

  void addAddedMembersToChatGroupHandler(
      String functionName, Function(String) handler) {
    _onAddedMembersToChatGroup[functionName] = handler;
  }

  void removeAddedMembersToChatGroupHandler(String callbackName) {
    _onAddedMembersToChatGroup.remove(callbackName);
  }

  void onAddedMembersToChatGroup(String content) {
    _onAddedMembersToChatGroup.forEach((key, value) {
      value(content);
    });
  }

  void addLeftChatGroupHandler(String functionName, Function(String) handler) {
    _onMemberLeftChatGroup[functionName] = handler;
  }

  void removeLeftChatGroupHandler(String callbackName) {
    _onMemberLeftChatGroup.remove(callbackName);
  }

  void onMemmberLeftChatGroup(String content) {
    _onMemberLeftChatGroup.forEach((key, value) {
      value(content);
    });
  }

  void addUpdatedGroupImageHandler(
      String functionName, Function(String) handler) {
    _onUpdatedGroupImageHandler[functionName] = handler;
  }

  void removeUpdatedGroupImageHandler(String callbackName) {
    _onUpdatedGroupImageHandler.remove(callbackName);
  }

  void onUpdatedGroupImage(String content) {
    _onUpdatedGroupImageHandler.forEach((key, value) {
      value(content);
    });
  }

  void addUpdatedGroupNameHandler(
      String functionName, Function(int, String) handler) {
    _onUpdatedGroupNameHandler[functionName] = handler;
  }

  void removeUpdatedGroupNameHandler(String callbackName) {
    _onUpdatedGroupNameHandler.remove(callbackName);
  }

  void onUpdatedGroupName(int groupId, String groupName) {
    _onUpdatedGroupNameHandler.forEach((key, value) {
      value(groupId, groupName);
    });
  }

  void addCreatedGroupHandler(String functionName, Function(String) handler) {
    _onCreatedGroupHandler[functionName] = handler;
  }

  void removeCreatedGroupHandler(String callbackName) {
    _onCreatedGroupHandler.remove(callbackName);
  }

  void onCreatedGroup(String content) {
    _onCreatedGroupHandler.forEach((key, value) {
      value(content);
    });
  }

  void addCreatedNewConversationWithFriend(
      String functionName, Function(String, int, int, String) handler) {
    _onCreatedNewFriendConversationHandler[functionName] = handler;
  }

  void removeCreatedNewConversationWithFriend(String callbackName) {
    _onCreatedNewFriendConversationHandler.remove(callbackName);
  }

  void onCreatedNewConversationWithFriend(
      String content, int newNumberOfFriends, int friendRequestId, String newFriendContent) {
    _onCreatedNewFriendConversationHandler.forEach((key, value) {
      value(content, newNumberOfFriends, friendRequestId, newFriendContent);
    });
  }

  void addReceivedChatMessageHandler(
      String functionName, Function(int, int, int, String, String, int) handler) {
    _onReceivedChatMessageHandler[functionName] = handler;
  }

  void removeReceivedChatMessageHandler(String callbackName) {
    _onReceivedChatMessageHandler.remove(callbackName);
  }

  void onReceivedChatMessage(
      int userId, int isImage, int isVideo, String content, String fromUserDetailsInfo, int messageId) {
    _onReceivedChatMessageHandler.forEach((key, value) {
      value(userId, isImage, isVideo, content, fromUserDetailsInfo, messageId);
    });
  }

  void addReceivedChatListMessageHandler(
      String functionName, Function(String) handler) {
    _onReceivedChatListMessageHandler[functionName] = handler;
  }

  void removeReceivedChatListMessageHandler(String callbackName) {
    _onReceivedChatListMessageHandler.remove(callbackName);
  }

  void onReceivedChatListMessage(String content) {
    _onReceivedChatListMessageHandler.forEach((key, value) {
      value(content);
    });
  }

  // ********** UNUSED

  void addAcceptedFriendRequestHandler(
      String functionName, Function(int) handler) {
    _onAcceptedFriendRequestHandler[functionName] = handler;
  }

  void removeAcceptedFriendRequestHandler(String callbackName) {
    _onAcceptedFriendRequestHandler.remove(callbackName);
  }

  void onAcceptedFriendRequest(int newNumberOfFriends) {
    _onAcceptedFriendRequestHandler.forEach((key, value) {
      value(newNumberOfFriends);
    });
  }

  // **********

  void addReceivedFriendRequestHandler(String functionName,
      Function(String) handler) {
    _onReceivedFriendRequestHandler[functionName] = handler;
  }

  void removeReceivedFriendRequestHandler(String callbackName) {
    _onReceivedFriendRequestHandler.remove(callbackName);
  }

  void onReceivedFriendRequest(
      String content) {
    _onReceivedFriendRequestHandler.forEach((key, value) {
      value(content);
    });
  }

  Future sendMessageToConversation(int fromId, int toId, int conversationId,
      String content, int isImage, int isVideo) async {
    await _hubConnection?.invoke("SendMessageToConversation",
        args: [fromId, toId, conversationId, content, isImage, isVideo]);
  }

  Future acceptFriendRequest(int friendRequestId, int fromId, int toId) async {
    await _hubConnection
        ?.invoke("AcceptFriendRequest", args: [friendRequestId, fromId, toId]);
  }

  Future sendFriendRequest(int fromUserId, int toUserId) async {
    await _hubConnection
        ?.invoke("SendFriendRequest", args: [fromUserId, toUserId]);
  }

  Future createGroupConversation(
      int creatorId, List<int> conversationMembers) async {
    await _hubConnection
        ?.invoke("CreateConversation", args: [creatorId, conversationMembers]);
  }

  Future updateGroupName(int groupId, String newGroupName, int userId) async {
    await _hubConnection
        ?.invoke("UpdateGroupDescription", args: [groupId, newGroupName, userId]);
  }

  Future updateGroupImage(int groupId, List<int> newImage, int userId) async {
    await _hubConnection?.invoke("UpdateGroupImage", args: [groupId, newImage, userId]);
  }

  Future leaveChatGroup(int groupId, int userId) async {
    await _hubConnection?.invoke("LeaveChatGroup", args: [groupId, userId]);
  }

  Future addUsersToChatGroup(
      int userWhoAdded, int groupId, List<int> usersToAdd) async {
    await _hubConnection?.invoke("AddUserToChatGroup",
        args: [userWhoAdded, groupId, usersToAdd]);
  }

  Future reactToMessage(int userId, int messageId, int conversationId) async {
    await _hubConnection
        ?.invoke("ReactToMessage", args: [userId, messageId, conversationId]);
  }

  Future removeReactionFromMessage(
      int userId, int messageId, int conversationId) async {
    await _hubConnection?.invoke("RemoveReactionFromMessage",
        args: [userId, messageId, conversationId]);
  }
}
