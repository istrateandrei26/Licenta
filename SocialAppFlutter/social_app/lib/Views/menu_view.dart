import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/Views/chat_list_view.dart';
import 'package:social_app/Views/events_view.dart';
import 'package:social_app/Views/notifications_view.dart';
import 'package:social_app/Views/review_view.dart';
import 'package:social_app/Views/user_profile_view.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Models/event_review_info.dart';
import '../services/ievents_service.dart';
import '../utilities/service_locator/locator.dart';

final GlobalKey<MenuViewState> menuKey =
    GlobalKey(debugLabel: "Menu Navigator");

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => MenuViewState();
}

class MenuViewState extends State<MenuView> {
  int _currentIndex = 0;

  final screens = [
    const ChatListView(),
    const EventsView(),
    Container(),
    const NotificationsView(),
    UserProfileView(userId: ProfileService.userId!)
  ];

  late StreamSubscription subscription;
  late StreamSubscription locationSubscription;

  var isDeviceConnected = false;
  var isLocationEnabled = false;
  bool isAlertSet = false;
  bool isLocationAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    getLocationServiceEnabled();
    super.initState();
  }

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        showInternetMissingSheet(
            icon: Icon(Icons.signal_cellular_nodata_outlined));
        setState(() {
          isAlertSet = true;
        });
      }
    });
  }

  getLocationServiceEnabled() {
    locationSubscription =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status != ServiceStatus.enabled || isLocationAlertSet == false) {
        showLocationServiceDisabledSheet(icon: Icon(Icons.location_disabled));
        setState(() {
          isLocationAlertSet = true;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    locationSubscription.cancel();
    super.dispose();
  }

  Future showLocationServiceDisabledSheet({required Icon icon}) =>
      showModalBottomSheet(
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          AppLocalizations.of(context)!
                              .location_not_enabled_text,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(
                              overflow: TextOverflow.fade,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          isLocationAlertSet = false;
                        });

                        isLocationEnabled =
                            await Geolocator.isLocationServiceEnabled();

                        if (!isLocationEnabled) {
                          showLocationServiceDisabledSheet(icon: icon);
                          setState(() {
                            isLocationAlertSet = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the value to change the button's corner radius
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .internet_sheet_no_connectivity_dismiss_message,
                        style: TextStyle(fontSize: 12),
                      ))
                ],
              )),
        ),
      );

  Future showInternetMissingSheet({required Icon icon}) => showModalBottomSheet(
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          AppLocalizations.of(context)!
                              .internet_sheet_no_connectivity_message,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(
                              overflow: TextOverflow.fade,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          isAlertSet = false;
                        });

                        isDeviceConnected =
                            await InternetConnectionChecker().hasConnection;

                        if (!isDeviceConnected) {
                          showInternetMissingSheet(icon: icon);
                          setState(() {
                            isAlertSet = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the value to change the button's corner radius
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .internet_sheet_no_connectivity_dismiss_message,
                        style: TextStyle(fontSize: 12),
                      ))
                ],
              )),
        ),
      );

  Future buildReviewSheet(EventReviewInfo eventReviewInfo) =>
      showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ReviewView(eventReviewInfo: eventReviewInfo),
      );

  void setChatListSelected() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void setEventFeedSelected() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void setNotificationsSelected() {
    setState(() {
      _currentIndex = 3;
    });
  }

  void setProfileSelected() {
    setState(() {
      _currentIndex = 4;
    });
  }

  int get currentIndex => _currentIndex;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if (ProfileService.eventsReviewAlreadyCalledOnce) return;

      ProfileService.eventsReviewAlreadyCalledOnce = true;
      
      var response = await provider
          .get<IEventsService>()
          .getEventsWithoutReview(ProfileService.userId!);
      if (response!.eventReviewInfos.isNotEmpty) {
        for (var eventReviewInfo in response.eventReviewInfos)
          buildReviewSheet(eventReviewInfo);
      }
    });
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(color: kPrimaryColor),
          iconSize: 25,
          showUnselectedLabels: true,
          selectedItemColor: kPrimaryColor,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          currentIndex: _currentIndex,
          onTap: (value) => setState(() {
            if (value == 2) {
              Navigator.pushNamed(context, "/CreateEventView");
            } else {
              _currentIndex = value;
            }
          }),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.messenger),
                label: AppLocalizations.of(context)!.menu_view_chats_text),
            BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: AppLocalizations.of(context)!.menu_view_events_text),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box, size: 40, color: kPrimaryColor),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label:
                    AppLocalizations.of(context)!.menu_view_notifications_text),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: AppLocalizations.of(context)!.menu_view_profile_text),
          ],
        ),
      ),
    );
  }
}
