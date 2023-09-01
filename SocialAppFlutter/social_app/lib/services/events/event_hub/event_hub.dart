import 'package:logging/logging.dart';
import 'package:mutex/mutex.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:social_app/utilities/logger/logger.dart';

import '../../../utilities/api_utility/api_manager.dart';
import '../../profile_service.dart';

final eventHubMutex = Mutex();

class EventHub {
  final String _serverUrl =
      "${ApiManager.eventServiceBaseUrl}/EventHub?accessToken=${ProfileService.accessToken}";
  HubConnection? _hubConnection;
  Map<String, dynamic Function(String, int)> _onNotifyMemberAddedHandler =
      Map();

  Map<String, dynamic Function(String, int)> _onNotifyMemberJoinedEventHandler =
      Map();

  Map<String, dynamic Function(int, int)> _onNotifyMemberQuitedHandler = Map();
  Map<String, dynamic Function(String)> _onAddedNewEventHandler = Map();
  Map<String, dynamic Function(String)> _onInvitedUserToEventHandler = Map();
  Map<String, dynamic Function(String)> _onReceivedHonor = Map();
  Map<String, dynamic Function(String)> _onReviewedOnlyEvent = Map();

  bool _connectionIsOpen = false;

  EventHub() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    final authorizeHeaderOption = MessageHeaders();
    authorizeHeaderOption.setHeaderValue(
        "EventHubBearer", ProfileService.accessToken);

    _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl,
            options: HttpConnectionOptions(
                headers: authorizeHeaderOption,
                logger: logger,
                logMessageContent: true,
                skipNegotiation: true,
                transport: HttpTransportType.WebSockets))
        .configureLogging(logger)
        .withAutomaticReconnect(
            retryDelays: [2000, 5000, 10000, 20000]).build();

    _hubConnection?.onclose(({error}) {
      _connectionIsOpen = false;
    });

    _hubConnection?.onreconnecting(({error}) {
      print("[!] Event client is reconnnecting...");
      _connectionIsOpen = false;
    });

    _hubConnection?.onreconnected(({connectionId}) {
      print("[+] Event client successfully reconnected...");
      _connectionIsOpen = true;
    });

    //register handler
    _hubConnection?.on("Added Event Member", (arguments) {
      onReceivedMemberAddedToEventNotification(
        (arguments as List)[0].toString(),
        int.parse((arguments as List)[1].toString()),
      );
    });

    _hubConnection?.on("Member Joined Event", (arguments) {
      onReceivedMemberJoinedEventNotification(
        (arguments as List)[0].toString(),
        int.parse((arguments as List)[1].toString()),
      );
    });

    _hubConnection?.on("Member Quited Event", (arguments) {
      onReceivedMemberQuitedEventNotification(
          int.parse((arguments as List)[0].toString()),
          int.parse((arguments as List)[1].toString()));
    });

    _hubConnection?.on("Event Added To Feed", (arguments) {
      onReceivedNewEventAddedToFeedNotification(
          (arguments as List)[0].toString());
    });

    _hubConnection?.on("Received Event Invitation", (arguments) {
      onReceivedNewInvitationToEvent((arguments as List)[0].toString());
    });

    _hubConnection?.on("Received Honor", (arguments) {
      onReceivedHonor((arguments as List)[0].toString());
    });

    _hubConnection?.on("Received Event Review Only", (arguments) {
      onReceivedEventOnlyReview((arguments as List)[0].toString());
    });
  }

  Future connect() async {
    await eventHubMutex.acquire();

    if (_hubConnection?.state != HubConnectionState.Connected) {
      await _hubConnection?.start();
      _connectionIsOpen = true;
    }

    eventHubMutex.release();

    return;
  }

  Future disconnect() async {
    eventHubMutex.acquire();

    await _hubConnection?.stop();
    _connectionIsOpen = false;

    eventHubMutex.release();
  }

  void addReviewedOnlyEventHandler(
      String functionName, Function(String) handler) {
    _onReviewedOnlyEvent[functionName] = handler;
  }

  void removeReviewedOnlyEventHandler(String callbackName) {
    _onReviewedOnlyEvent.remove(callbackName);
  }

  void onReceivedEventOnlyReview(String content) {
    _onReviewedOnlyEvent.forEach((key, value) {
      value(content);
    });
  }

  void addHonoredMemberHandler(String functionName, Function(String) handler) {
    _onReceivedHonor[functionName] = handler;
  }

  void removeHonoredMemberHandler(String callbackName) {
    _onReceivedHonor.remove(callbackName);
  }

  void onReceivedHonor(String content) {
    _onReceivedHonor.forEach((key, value) {
      value(content);
    });
  }

  void addInvitedUserToEventHandler(
      String functionName, Function(String) handler) {
    _onInvitedUserToEventHandler[functionName] = handler;
  }

  void removeInvitedUserToEventHandler(String callbackName) {
    _onInvitedUserToEventHandler.remove(callbackName);
  }

  void onReceivedNewInvitationToEvent(String content) {
    _onInvitedUserToEventHandler.forEach((key, value) {
      value(content);
    });
  }

  void addNotifyAddedMemberToEventHandler(
      String functionName, Function(String, int) handler) {
    _onNotifyMemberAddedHandler[functionName] = handler;
  }

  void addNotifyMemberJoinedEventHandler(
      String functionName, Function(String, int) handler) {
    _onNotifyMemberJoinedEventHandler[functionName] = handler;
  }

  void addNewEventToFeedHandler(String functionName, Function(String) handler) {
    _onAddedNewEventHandler[functionName] = handler;
  }

  void removeNewEventToFeedHandler(String callbackName) {
    _onAddedNewEventHandler.remove(callbackName);
  }

  void onReceivedNewEventAddedToFeedNotification(String content) {
    _onAddedNewEventHandler.forEach((key, value) {
      value(content);
    });
  }

  void addNotifyMemberQuitedEventHandler(
      String functionName, Function(int, int) handler) {
    _onNotifyMemberQuitedHandler[functionName] = handler;
  }

  void removeNotifyMemberJoinedEventHandler(String callbackName) {
    _onNotifyMemberJoinedEventHandler.remove(callbackName);
  }

  void removeNotifyAddedMemberToEventHandler(String callbackName) {
    _onNotifyMemberAddedHandler.remove(callbackName);
  }

  void removeNotifyMemberQuitedEventHandler(String callbackName) {
    _onNotifyMemberQuitedHandler.remove(callbackName);
  }

  void onReceivedMemberAddedToEventNotification(
      String newMemberInfo, int eventId) {
    _onNotifyMemberAddedHandler.forEach((key, value) {
      value(newMemberInfo, eventId);
    });
  }

  void onReceivedMemberJoinedEventNotification(
      String newMemberInfo, int eventId) {
    _onNotifyMemberJoinedEventHandler.forEach((key, value) {
      value(newMemberInfo, eventId);
    });
  }

  void onReceivedMemberQuitedEventNotification(int memberId, int eventId) {
    _onNotifyMemberQuitedHandler.forEach((key, value) {
      value(memberId, eventId);
    });
  }

  Future addMemberToEvent(int memberId, int eventId) async {
    await _hubConnection
        ?.invoke("NotifyMemberAddedToEvent", args: [memberId, eventId]);
  }

  Future removeMemberFromEvent(int memberId, int eventId) async {
    await _hubConnection
        ?.invoke("NotifyMemberQuitedEvent", args: [memberId, eventId]);
  }

  Future addNewEventToFeed(
      int eventId, List<int> allMembers, int creatorId) async {
    await _hubConnection
        ?.invoke("AddNewEventToFeed", args: [eventId, allMembers, creatorId]);
  }

  Future honorMembers(List<int> honoredUsers, int eventId, int fromId) async {
    await _hubConnection
        ?.invoke("HonorMembers", args: [honoredUsers, eventId, fromId]);
  }

  Future reviewOnlyEvent(int eventId, int ratingScore, int fromId) async {
    await _hubConnection
        ?.invoke("ReviewOnlyEvent", args: [eventId, ratingScore, fromId]);
  }

  Future inviteFriendsToEvent(
      int eventId, List<int> usersToInvite, int userId) async {
    await _hubConnection
        ?.invoke("InviteUsersToEvent", args: [eventId, usersToInvite, userId]);
  }
}
