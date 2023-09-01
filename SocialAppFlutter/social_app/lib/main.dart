import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Views/api_test.dart';
import 'package:social_app/Views/card_form_view.dart';
import 'package:social_app/Views/change_password_view.dart';
import 'package:social_app/Views/chat_list_view.dart';
import 'package:social_app/Views/conversation_details_view.dart';
import 'package:social_app/Views/conversation_view.dart';
import 'package:social_app/Views/create_event_view.dart';
import 'package:social_app/Views/event_details_view.dart';
import 'package:social_app/Views/event_invites_view.dart';
import 'package:social_app/Views/events_view.dart';
import 'package:social_app/Views/friend_requests_view.dart';
import 'package:social_app/Views/login_view.dart';
import 'package:social_app/Views/menu_view.dart';
import 'package:social_app/Views/owner_choice_view.dart';
import 'package:social_app/Views/payment_verification_code_view.dart';
import 'package:social_app/Views/request_new_location_view.dart';
import 'package:social_app/Views/reset_password_view.dart';
import 'package:social_app/Views/settings_view.dart';
import 'package:social_app/Views/user_profile_view.dart';
import 'package:social_app/blocs/blocs.dart';
import 'package:social_app/services/google/google_sign_in_service.dart';
import 'package:social_app/services/local_database/sqlite_database_service.dart';
import 'package:social_app/services/local_notification_service.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/services/remember_me_service.dart';
import 'package:social_app/user_settings.dart/user_location_info.dart';
import 'package:social_app/user_settings.dart/user_settings.dart';
import 'package:social_app/utilities/service_locator/locator.dart';
import 'package:social_app/utilities/theme.dart';
import 'Views/no_connection_view.dart';
import 'services/firebase_notification_service.dart/notifications_services.dart';
import 'utilities/http_client_utility/http_client_helper.dart';
import 'package:timezone/data/latest.dart' as tz;

import '.env';

Future main() async {
  //setup necessary services:
  setupServices();

  //cert trust:
  HttpOverrides.global = MyHttpOverrides(); // trust self-signed certificates

  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService()
      .initNotification(); // initialize local notification service
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Stripe req:
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();

  // set preferred language
  await UserSettings.setPreferredLanguage();

  // set user settings as far as the calendar is concerned:
  await UserSettings.setGoogleCalendarEnabled();
  await UserSettings.setLocalCalendarEnabled();

  // set user settings as far as the location is concerned:
  await UserLocationInfo.initializeLocationInfoForUser();

  // delete sqlite database:
  // await SqliteDatabaseHelper.deleteLocalDatabase();

  hasInternetConnection = await InternetConnectionChecker().hasConnection;
  if (hasInternetConnection) {
    // SEARCH FOR USER IN SQLITE LOCAL DATABASE and then get his profile from auth microservice
    await RememberMeService.initializeLoggedInUserIfAny();
  }
  runApp(MyApp(key: mainKey));
}

bool hasInternetConnection = true;

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

final GlobalKey<_MyAppState> mainKey =
    GlobalKey(debugLabel: "Main App Navigator");

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = Locale(UserSettings.preferredLanguageCode);
  NotificationServices notificationServices = NotificationServices();
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    super.initState();
    // final firebaseMessaging = FCM();
    // firebaseMessaging.requestPermission();
    // firebaseMessaging.loadFCM();
    // firebaseMessaging.listenFCM();
    // FirebaseMessaging.instance.getToken().then((value) {
    //   print(value);
    // });
    if (hasInternetConnection) {
      notificationServices.requestNotificationPermission();
      notificationServices.firebaseInit();
      notificationServices.setupInteractMessage();
      notificationServices.isTokenRefresh();
      notificationServices.getDeviceToken().then((value) {
        if (kDebugMode) {
          print('device token');
          print(value);
        }
      });
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool google_signin_dev = true;

    return hasInternetConnection
        ? ChangeNotifierProvider(
            create: (context) => GoogleSignInService(),
            child: BlocProvider(
              create: (context) => PaymentBloc(),
              child: MaterialApp(
                  locale: _locale,
                  navigatorKey: navigatorKey,
                  onGenerateRoute: (settings) {
                    switch (settings.name) {
                      case "/LoginView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => const LoginView(),
                          );
                        }
                      case "/CardFormView":
                        {
                          // statements;
                          final approvedLocationId = int.parse(
                              ((settings.arguments as List)[0]).toString());

                          final String ownerEmail =
                              ((settings.arguments as List)[1]).toString();

                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => CardFormView(
                                approvedLocationId: approvedLocationId,
                                ownerEmail: ownerEmail),
                          );
                        }
                      case "/PaymentVerificationCodeView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) =>
                                const PaymentVerificationCodeView(),
                          );
                        }
                      case "/RequestNewLocationView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) =>
                                const RequestNewLocationView(),
                          );
                        }
                      case "/OwnerChoiceView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) =>
                                const OwnerChoiceView(),
                          );
                        }
                      case "/ResetPasswordView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) =>
                                const ResetPasswordView(),
                          );
                        }
                      case "/ChangePasswordView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) =>
                                const ChangePasswordView(),
                          );
                        }
                      case "/SettingsView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => const SettingsView(),
                          );
                        }

                      case "/ChatListView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => const ChatListView(),
                          );
                        }

                      case "/ConversationView":
                        {
                          // statements;
                          final conversationId = int.parse(
                              ((settings.arguments as List)[0]).toString());

                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => ConversationView(
                                conversationId: conversationId),
                          );
                        }

                      case "/ConversationDetailsView":
                        {
                          final isGroup = ((settings.arguments as List)[0])
                                  .toString()
                                  .toLowerCase() ==
                              "true";
                          final members = (settings.arguments as List)[1];
                          final conversationDetailName =
                              ((settings.arguments as List)[2]).toString();
                          final conversationDetailImage =
                              (settings.arguments as List)[3];
                          final conversationId = int.parse(
                              ((settings.arguments as List)[4]).toString());
                          final friends = (settings.arguments as List)[5];

                          return PageRouteBuilder(
                              settings: settings,
                              pageBuilder: (_, __, ___) =>
                                  ConversationDetailsView(
                                    isGroup: isGroup,
                                    members: members,
                                    conversationDetailName:
                                        conversationDetailName,
                                    conversationDetailImage:
                                        conversationDetailImage,
                                    conversationId: conversationId,
                                    friends: friends,
                                  ));
                        }
                      case "/EventDetailsView":
                        {
                          // statements;

                          final eventId = int.parse(
                              ((settings.arguments as List)[0]).toString());

                          final sportCategoryImage =
                              ((settings.arguments as List)[1]).toString();

                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => EventDetailsView(
                              eventId: eventId,
                              sportCategoryImage: sportCategoryImage,
                            ),
                          );
                        }

                      case "/EventsView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => const EventsView(),
                          );
                        }

                      case "/EventInvitesView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) =>
                                const EventInvitesView(),
                          );
                        }

                      case "/UserProfileView":
                        {
                          final userId = int.parse(
                              ((settings.arguments as List)[0]).toString());

                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) =>
                                UserProfileView(userId: userId),
                          );
                        }

                      case "/FriendRequestsView":
                        {
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) =>
                                const FriendRequestsView(),
                          );
                        }

                      case "/CreateEventView":
                        {
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) =>
                                const CreateEventView(),
                          );
                        }

                      case "/MenuView":
                        {
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => const MenuView(),
                          );
                        }
                      case "/ApiTestView":
                        {
                          // statements;
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => const ApiTestView(),
                          );
                        }
                    }
                    return null;
                  },
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  debugShowCheckedModeBanner: false,
                  theme: lightThemeData(context),
                  darkTheme: darkThemeData(context),
                  themeMode: ThemeMode.light,
                  home: google_signin_dev
                      ? StreamBuilder(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator.adaptive());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text("Something went wrong"));
                            } else if (snapshot.hasData) {
                              var googleServiceInstance =
                                  Provider.of<GoogleSignInService>(context,
                                      listen: false);
                              googleServiceInstance.googleSimpleSignIn();

                              // ProfileService.signedInWithGoogle = true;

                              // googleServiceInstance
                              //     .getGoogleSignInProfileInfoAndUpdateProfile();

                              // while (!canProceedToMenu) {}

                              return const MenuView();
                            } else {
                              if (ProfileService.userId != null) {
                                return const MenuView();
                              }
                              
                              return const LoginView();
                            }
                          },
                        )
                      // : const UserProfileView(userId: 34),
                      // : const ApiTestView()
                      // : const ConversationDetailsView()
                      // : const ConversationView(
                      //     conversationId: 3031,
                      //     conversationDescription: "You,Marina,Andrei,Gabriel",
                      //   )
                      // : const ChatListView()
                      // : const CreateEventView()
                      // : const EventsView()
                      // : const LoginView()
                      // : const ResetPasswordView()
                      // : const RequestNewLocationView()
                      : const LoginView()),
            ))
        : MaterialApp(
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            debugShowCheckedModeBanner: false,
            theme: lightThemeData(context),
            darkTheme: darkThemeData(context),
            themeMode: ThemeMode.light,
            home: NoConnectionView());
  }
}
