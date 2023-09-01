import 'package:flutter/material.dart';
import 'package:social_app/Views/conversation_details_view.dart';
import 'package:social_app/Views/event_details_view.dart';
import 'package:social_app/Views/friend_requests_view.dart';
import 'package:social_app/Views/notifications_view.dart';
import 'package:social_app/main.dart';

import '../../Views/conversation_view.dart';
import '../../Views/menu_view.dart';

class NotificationUtilityInfo {
  static const String FRIEND_REQUESTS_SCREEN = "/FriendRequestsView";
  static const String CONVERSATION_SCREEN = "/ConversationView";
  static const String EVENT_DETAILS_SCREEN = "/EventDetailsView";
  static const String EVENT_INVITES_VIEW = "/EventInvitesView";
}

class PushNotificationClickHelper {
  final String _screenInfo;

  PushNotificationClickHelper(this._screenInfo);

  bool ConversationViewAndConversationDetailsViewOpened(int conversationId) {
    return conversationKey.currentState != null &&
        conversationKey.currentState!.mounted &&
        conversationKey.currentState?.conversationId == conversationId &&
        conversationDetailsKey.currentState != null &&
        conversationDetailsKey.currentState!.mounted &&
        conversationDetailsKey.currentState?.conversationId == conversationId;
  }

  bool ConversationViewAndConversationDetailsViewNotOpened(int conversationId) {
    var conversationViewOpened = conversationKey.currentState != null &&
        conversationKey.currentState!.mounted &&
        conversationKey.currentState?.conversationId == conversationId;

    var detailsViewNotOpened = conversationDetailsKey.currentState == null ||
        !conversationDetailsKey.currentState!.mounted ||
        conversationDetailsKey.currentState?.conversationId != conversationId;

    return conversationViewOpened && detailsViewNotOpened;
  }

  void parseScreenInfoAndHandleNavigation() async {
    var tokens = _screenInfo.split(",");
    var viewName = tokens[0];

    switch (viewName) {
      case NotificationUtilityInfo.CONVERSATION_SCREEN:
        final conversationId = int.parse(tokens[1]);

        if (ConversationViewAndConversationDetailsViewOpened(conversationId)) {
          navigatorKey.currentState?.pop();
        } else {
          navigatorKey.currentState?.popUntil((route) => route.isFirst);
          menuKey.currentState?.setChatListSelected();
          navigatorKey.currentState?.push<void>(
            MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    ConversationView(key: conversationKey, conversationId: conversationId)),
          );
        }
        break;

      case NotificationUtilityInfo.EVENT_DETAILS_SCREEN:
        final eventId = int.parse(tokens[1]);
        final sportCategoryImage = tokens[2];
        navigatorKey.currentState?.popUntil((route) => route.isFirst);

        menuKey.currentState?.setEventFeedSelected();
        navigatorKey.currentState?.push<void>(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => EventDetailsView(
                  eventId: eventId, sportCategoryImage: sportCategoryImage)),
        );
        break;

      case NotificationUtilityInfo.FRIEND_REQUESTS_SCREEN:
        navigatorKey.currentState?.popUntil((route) => route.isFirst);
        menuKey.currentState?.setNotificationsSelected();
        //select friend requests tab, with index 0:
        notificationsTabController.animateTo(0);
        navigatorKey.currentState?.push<void>(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => FriendRequestsView()),
        );
        break;

      case NotificationUtilityInfo.EVENT_INVITES_VIEW:
        navigatorKey.currentState?.popUntil((route) => route.isFirst);
        menuKey.currentState?.setNotificationsSelected();
        //select event invites tab, with index 1:
        notificationsTabController.animateTo(1);
        break;
      default:
    }
  }
}
