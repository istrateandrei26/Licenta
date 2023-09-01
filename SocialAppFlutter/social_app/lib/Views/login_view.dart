import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/ViewModels/login_view_model.dart';
import 'package:social_app/Views/owner_choice_view.dart';
import 'package:social_app/Views/register_view.dart';
import 'package:social_app/Views/reset_password_view.dart';
import 'package:social_app/Views/user_profile_view.dart';
import 'package:social_app/components/classic_button.dart';
import 'package:social_app/components/button_progress.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:stacked/stacked.dart';
import '../components/google_sign_in_button.dart';
import '../services/iauth_service.dart';
import '../services/local_database/sqlite_database_service.dart';
import '../utilities/constants.dart';
import '../utilities/service_locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'menu_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

  Future buildInformationSheet({required String message, required Icon icon}) =>
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (context) => Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                        message,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: const TextStyle(
                            overflow: TextOverflow.fade,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            )),
      );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (context, model, child) => GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.4,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(90)),
                            color: kPrimaryColor),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: height / 3,
                                width: height / 3,
                                child: GestureDetector(
                                  child: Image.asset(
                                      "assets/images/logo_image.png"),
                                  onTap: () {
                                    // Navigator.pushNamed(
                                    //     context, "/ApiTestView");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: kDefaultPadding,
                            right: kDefaultPadding,
                            top: kDefaultPadding * 2),
                        padding: const EdgeInsets.only(
                            left: kDefaultPadding, right: kDefaultPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: model.usernameController,
                          maxLength: 20,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                            counterText: '',
                            icon: Icon(
                              Icons.person,
                              color: kPrimaryColor,
                            ),
                            hintText: AppLocalizations.of(context)!
                                .username_placeholder,
                            hintStyle: TextStyle(fontSize: 14),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: kDefaultPadding,
                            right: kDefaultPadding,
                            top: kDefaultPadding),
                        padding: const EdgeInsets.only(
                            left: kDefaultPadding, right: kDefaultPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: model.passwordController,
                          maxLength: 20,
                          cursorColor: kPrimaryColor,
                          obscureText: true,
                          decoration: InputDecoration(
                            counterText: '',
                            icon: Icon(
                              Icons.lock,
                              color: kPrimaryColor,
                            ),
                            hintText: AppLocalizations.of(context)!
                                .password_placeholder,
                            hintStyle: TextStyle(fontSize: 14),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: kDefaultPadding, right: kDefaultPadding),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          child: Text(
                            AppLocalizations.of(context)!.forgot_password_text,
                            style:
                                TextStyle(fontSize: 10, color: kPrimaryColor),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordView()),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (model.username.isEmpty ||
                              model.password.isEmpty) {
                            buildInformationSheet(
                              message: AppLocalizations.of(context)!
                                  .request_new_location_view_please_fill_fields_text,
                              icon: const Icon(
                                Icons.info,
                                size: 50,
                                color: Colors.blue,
                              ),
                            );

                            return;
                          }

                          var response = await model.logIn();
                          if (response?.username == "") {
                            buildInformationSheet(
                              message: response!.message,
                              icon: const Icon(
                                Icons.info,
                                size: 50,
                                color: Colors.blue,
                              ),
                            );
                          } else if (response?.type ==
                                  Type.invalidUsernameOrPassword &&
                              response?.username != "") {
                            buildInformationSheet(
                              message: AppLocalizations.of(context)!
                                  .invalid_username_or_password_text,
                              icon: const Icon(
                                Icons.info,
                                size: 50,
                                color: Colors.blue,
                              ),
                            );
                          } else if (response?.statusCode == 200) {
                            // showDialog(
                            //     context: context,
                            //     builder: (_) => AlertDialog(
                            //           title: const Text("Login"),
                            //           content: Text(response!.accessToken),
                            //         ));

                            // storage.write(
                            //     key: "username", value: response!.username);
                            //navigate to chat list:

                            ProfileService.updateProfileInfo(response!);

                            await SqliteDatabaseHelper.instance.add(LoggedUser(
                                userId: ProfileService.userId!,
                                signedWithGoogle: 0));
                            FirebaseMessaging.instance.getToken().then((value) {
                              provider
                                  .get<IAuthService>()
                                  .addDeviceId(ProfileService.userId!, value!);
                            });

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuView(
                                        key: menuKey,
                                      )),
                            );

                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => UserProfileView(
                            //             userId: ProfileService.userId!,
                            //           )),
                            // );

                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => CupertinoTestView()),
                            //   );

                            // Navigator.pushReplacementNamed(context, '/CreateEventView');
                          }
                        },
                        child: model.processing
                            ? const ButtonProgressIndicator()
                            : ClassicButton(
                                text: AppLocalizations.of(context)!.login_text,
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GoogleSignInButton(
                        text: AppLocalizations.of(context)!
                            .sign_up_with_google_text,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: kDefaultPadding / 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                      .do_not_have_an_account_text +
                                  " ",
                              style: TextStyle(fontSize: 11),
                            ),
                            GestureDetector(
                              onTap: (() => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterView()))
                                  }),
                              child: Text(
                                AppLocalizations.of(context)!.register_now_text,
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 11),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OwnerChoiceView()))
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.shade200,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          margin:
                              const EdgeInsets.only(top: kDefaultPadding / 2),
                          child: Text(
                            AppLocalizations.of(context)!.i_own_a_location_text,
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 10),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
