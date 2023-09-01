import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/main.dart';
import 'package:social_app/services/chat/chat_hub/chat_hub.dart';
import 'package:social_app/services/events/event_hub/event_hub.dart';
import 'package:social_app/services/local_database/sqlite_database_service.dart';
import 'package:social_app/services/preferences_service.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/user_settings.dart/user_settings.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:social_app/utilities/service_locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/google/google_sign_in_service.dart';
import '../services/iauth_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool googleCalendarEnabled = UserSettings.googleCalendarEnabled;
  bool localCalendarEnabled = UserSettings.localCalendarEnabled;
  String selectedLanguage = UserSettings.preferredLanguageCode;

  bool processingLogOut = false;

  late StreamSubscription subscription;
  late StreamSubscription locationSubscription;

  var isDeviceConnected = false;
  var isLocationEnabled = false;
  bool isAlertSet = false;
  bool isLocationAlertSet = false;

  @override
  void initState() {
    // getConnectivity();
    // getLocationServiceEnabled();
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
    // subscription.cancel();
    // locationSubscription.cancel();
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

                        isLocationEnabled = await Geolocator.isLocationServiceEnabled();

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

  onChangePreferredLanguageCode(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
      UserSettings.preferredLanguageCode = languageCode;
      PreferencesService.setPreferredLanguage(languageCode);
    });
  }

  onChangeGoogleCalendarEnabled(bool enabled) {
    setState(() {
      googleCalendarEnabled = enabled;
      // print("Google Calendar enabled: ${googleCalendarEnabled}");
      UserSettings.googleCalendarEnabled = enabled;
      PreferencesService.setGoogleCalendarEnabled(enabled);
    });

    if (!enabled) return;

    localCalendarEnabled = !googleCalendarEnabled;
    UserSettings.localCalendarEnabled = !UserSettings.googleCalendarEnabled;
    PreferencesService.setLocalCalendarEnabled(
        !UserSettings.googleCalendarEnabled);
  }

  onChangeLocalCalendarEnabled(bool enabled) {
    setState(() {
      localCalendarEnabled = enabled;
      // print("Local Calendar enabled: ${localCalendarEnabled}");
      UserSettings.localCalendarEnabled = enabled;
      PreferencesService.setLocalCalendarEnabled(enabled);
    });

    if (!enabled) return;

    googleCalendarEnabled = !localCalendarEnabled;
    UserSettings.googleCalendarEnabled = !UserSettings.localCalendarEnabled;
    PreferencesService.setGoogleCalendarEnabled(
        !UserSettings.localCalendarEnabled);
  }

  Future LogOut() async {
    setState(() {
      processingLogOut = true;
    });

    if (ProfileService.signedInWithGoogle) {
      final provider = Provider.of<GoogleSignInService>(context, listen: false);
      await provider.googleLogout();
    } else {
      await Future.delayed(const Duration(seconds: 3));
    }

    // clear cached logged in user
    if (ProfileService.userId != null) {
      await SqliteDatabaseHelper.deleteLocalDatabase();
    }

    // remove preferences
    await PreferencesService.removeCachedCoordinates();
    await PreferencesService.removeCalendarSettings();
    await PreferencesService.removeSavedLanguage();

    //disconnect from real time services:
    await provider.get<ChatHub>().disconnect();
    await provider.get<EventHub>().disconnect();


    //remove device token when sign out from personal account
    var deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      await provider
          .get<IAuthService>()
          .removeDeviceId(ProfileService.userId!, deviceToken);

    // clear profile info:
    ProfileService.clearProfileInfo();
    
    }

    SystemNavigator.pop();

    setState(() {
      processingLogOut = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
            .conversation_details_view_settings_text),
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: SettingsOptionWidget(
                icon: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.password, color: Colors.white),
                ),
                title: AppLocalizations.of(context)!
                    .change_password_view_change_password_text,
                onPressed: () =>
                    Navigator.pushNamed(context, "/ChangePasswordView"),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Column(children: [
                if (ProfileService.signedInWithGoogle)
                  SettingOptionSwitchWidget(
                      icon: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.calendar_month, color: Colors.white),
                      ),
                      title: AppLocalizations.of(context)!
                          .settings_view_google_calendar,
                      enabled: googleCalendarEnabled,
                      onChangeFunction: onChangeGoogleCalendarEnabled),
                SettingOptionSwitchWidget(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child:
                          Icon(Icons.phone_android_sharp, color: Colors.white),
                    ),
                    title: AppLocalizations.of(context)!
                        .settings_view_local_calendar,
                    enabled: localCalendarEnabled,
                    onChangeFunction: onChangeLocalCalendarEnabled),
              ]),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LanguageButton(
                  languageCode: 'ro',
                  flagImage: 'romania.png',
                  isSelected: selectedLanguage == 'ro',
                  onTap: () {
                    onChangePreferredLanguageCode('ro');
                    mainKey.currentState
                        ?.setLocale(Locale.fromSubtags(languageCode: 'ro'));
                  },
                ),
                LanguageButton(
                  languageCode: 'en',
                  flagImage: 'united-kingdom.png',
                  isSelected: selectedLanguage == 'en',
                  onTap: () {
                    onChangePreferredLanguageCode('en');
                    mainKey.currentState
                        ?.setLocale(Locale.fromSubtags(languageCode: 'en'));
                  },
                ),
                LanguageButton(
                  languageCode: 'fr',
                  flagImage: 'france.png',
                  isSelected: selectedLanguage == 'fr',
                  onTap: () {
                    onChangePreferredLanguageCode('fr');
                    mainKey.currentState
                        ?.setLocale(Locale.fromSubtags(languageCode: 'fr'));
                  },
                ),
                LanguageButton(
                  languageCode: 'es',
                  flagImage: 'spain.png',
                  isSelected: selectedLanguage == 'es',
                  onTap: () {
                    onChangePreferredLanguageCode('es');
                    mainKey.currentState
                        ?.setLocale(Locale.fromSubtags(languageCode: 'es'));
                  },
                ),
              ],
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: RawMaterialButton(
                      onPressed: () async {
                        if (processingLogOut) return;
                        await LogOut();
                      },
                      elevation: 2.0,
                      fillColor: Colors.red[400],
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      child: processingLogOut
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Icon(
                              Icons.logout,
                              size: 25.0,
                              color: Colors.white,
                            ),
                    ),
                  )),
            ),
            const SizedBox(height: 10.0)
          ],
        ),
      ),
    );
  }
}

class LanguageButton extends StatefulWidget {
  final String languageCode;
  final String flagImage;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageButton({
    Key? key,
    required this.languageCode,
    required this.flagImage,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.blue.shade200 : Colors.transparent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 25,
          child: Image.asset("assets/icons/${widget.flagImage}"),
        ),
      ),
    );
  }
}

class SettingOptionSwitchWidget extends StatelessWidget {
  const SettingOptionSwitchWidget({
    Key? key,
    required this.title,
    required this.enabled,
    required this.onChangeFunction,
    required this.icon,
  }) : super(key: key);

  final String title;
  final bool enabled;
  final Function onChangeFunction;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12.0),
          Text(title,
              style: const TextStyle(fontSize: 13, color: Colors.black)),
          const Spacer(),
          Transform.scale(
              scale: 1,
              child: Switch.adaptive(
                activeColor: kPrimaryColor,
                trackColor: MaterialStateProperty.all(Colors.grey),
                value: enabled,
                onChanged: (value) => {onChangeFunction(value)},
              )),
        ],
      ),
    );
  }
}

class SettingsOptionWidget extends StatelessWidget {
  const SettingsOptionWidget({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 12.0),
            Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}
