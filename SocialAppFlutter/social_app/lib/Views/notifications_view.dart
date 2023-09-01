import 'package:flutter/material.dart';
import 'package:social_app/Views/event_invites_view.dart';
import 'package:social_app/Views/friend_requests_view.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late TabController notificationsTabController;

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    notificationsTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    notificationsTabController.dispose();
    super.dispose();
  }

  void selectFriendRequestsTab() {
    notificationsTabController.animateTo(0);
  }

  void selectEventInvitesTab() {
    notificationsTabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text(AppLocalizations.of(context)!.menu_view_notifications_text),
      ),
      body: DefaultTabController(
          length: 2,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Theme(
                  data: ThemeData(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                      controller: notificationsTabController,
                      labelStyle: const TextStyle(fontSize: 12),
                      labelColor: const Color.fromARGB(255, 20, 79, 128),
                      unselectedLabelColor: Colors.grey[400],
                      indicatorWeight: 1,
                      indicatorColor: const Color.fromARGB(255, 20, 79, 128),
                      tabs: [
                        Tab(
                          icon: Icon(Icons.group, size: 18),
                          child: Text(AppLocalizations.of(context)!.notifications_view_friend_requests_text, style: TextStyle(fontSize: 10),),
                          height: 45,
                          iconMargin: EdgeInsets.only(bottom: 5.0),
                        ),
                        Tab(
                          icon: Icon(Icons.event, size: 18),
                          child: Text(AppLocalizations.of(context)!.notifications_view_event_invites_text, style: TextStyle(fontSize: 10),),
                          height: 45,
                          iconMargin: EdgeInsets.only(bottom: 5.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                      controller: notificationsTabController,
                      children: [FriendRequestsView(), EventInvitesView()]),
                )
              ],
            ),
          )),
    );
  }
}
