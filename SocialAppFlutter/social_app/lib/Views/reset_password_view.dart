import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/ViewModels/reset_password_view_model.dart';
import 'package:social_app/Views/create_event_view.dart';
import 'package:social_app/components/classic_button.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/button_progress.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  PageController pageController = PageController(initialPage: 0);
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            )),
      );

  void nextPage() {
    // setState(() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.linearToEaseOut);
    // });
  }

  void previousPage() {
    // setState(() {
    pageController.previousPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.linearToEaseOut);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ResetPasswordViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: PageView(
              controller: pageController,
              physics: const BouncingScrollPhysics(),
              children: [
                Column(
                  children: [
                    ActionPageButton(
                      onTap: previousPage,
                      canQuit: true,
                      canGoBack: false,
                    ),
                     Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
                      child: Text(
                          AppLocalizations.of(context)!
                              .reset_password_view_text,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15)),
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
                        color: model.isValidEmail
                            ? Colors.grey[200]
                            : Colors.red[100],
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: model.emailController,
                        maxLength: 30,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          counterText: '',
                          icon: Icon(
                            Icons.mail,
                            color: kPrimaryColor,
                          ),
                          hintText: AppLocalizations.of(context)!
                              .reset_password_view_email_address_placeholder_text,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          model.setIsValidEmail(EmailValidator.validate(value));
                        },
                      ),
                    ),
                   
                    Expanded(
                      child: Icon(
                        Icons.email_outlined,
                        color: kPrimaryColor,
                        size: screenWidth * 0.8,
                      ),
                    ),
                    // const Spacer(),
                    model.resetCodeSending
                        ? SizedBox(
                            width: screenWidth * 0.6,
                            child: const ButtonProgressIndicator())
                        : GestureDetector(
                            onTap: () async {
                              model.setResetCodeSending(true);

                              if (!model.isValidEmail) {
                                buildInformationSheet(
                                  message: AppLocalizations.of(context)!
                                      .please_check_inputs_text,
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                );
                                model.setResetCodeSending(false);
                                return;
                              }

                              if (model.email.isEmpty) {
                                buildInformationSheet(
                                  message: AppLocalizations.of(context)!
                                      .reset_password_view_please_text,
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                );
                                model.setResetCodeSending(false);
                                return;
                              }

                              var response = await model.generateResetCode();
                              if (response!.wrongEmail) {
                                buildInformationSheet(
                                  message: AppLocalizations.of(context)!
                                      .reset_password_view_email_not_found_text,
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                );
                                model.setResetCodeSending(false);
                                return;
                              }

                              nextPage();
                              model.setResetCodeSending(false);
                            },
                            child: SizedBox(
                                width: screenWidth * 0.6,
                                child: ClassicButton(
                                    text: AppLocalizations.of(context)!
                                        .reset_password_view_submit_text)),
                          ),
                    const SizedBox(height: 30)
                  ],
                ),
                Column(
                  children: [
                    ActionPageButton(
                      onTap: previousPage,
                      canQuit: true,
                      canGoBack: true,
                    ),
                    Text(
                        AppLocalizations.of(context)!
                            .reset_password_view_confirm_text,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18)),
                    Container(
                      margin: const EdgeInsets.only(
                          left: kDefaultPadding,
                          right: kDefaultPadding,
                          top: kDefaultPadding * 1.5),
                      padding: const EdgeInsets.only(
                          left: kDefaultPadding, right: kDefaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: model.resetCodeController,
                        maxLength: 8,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          counterText: '',
                          icon: Icon(
                            Icons.security,
                            color: kPrimaryColor,
                          ),
                          hintText: AppLocalizations.of(context)!
                              .reset_password_view_reset_code_placheholder_text,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: kDefaultPadding,
                          right: kDefaultPadding,
                          top: kDefaultPadding * 1.5),
                      padding: const EdgeInsets.only(
                          left: kDefaultPadding, right: kDefaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: model.isValidPassword
                            ? Colors.grey[200]
                            : Colors.red[100],
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: model.newPasswordController,
                        maxLength: 20,
                        cursorColor: kPrimaryColor,
                        obscureText: true,
                        decoration: InputDecoration(
                          counterText: '',
                          icon: Icon(
                            Icons.password,
                            color: kPrimaryColor,
                          ),
                          hintText: AppLocalizations.of(context)!
                              .reset_password_view_new_pass_placeholder_text,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          final passwordRegex = RegExp(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*])(?=.*\d).{8,20}$');
                          model.setIsValidPassword(
                              passwordRegex.hasMatch(value));
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: kDefaultPadding,
                          right: kDefaultPadding,
                          top: kDefaultPadding * 1.5),
                      padding: const EdgeInsets.only(
                          left: kDefaultPadding, right: kDefaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: model.isValidConfirmPassword
                            ? Colors.grey[200]
                            : Colors.red[100],
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: model.confirmNewPasswordController,
                        maxLength: 20,
                        cursorColor: kPrimaryColor,
                        obscureText: true,
                        decoration: InputDecoration(
                          counterText: '',
                          icon: Icon(
                            Icons.password,
                            color: kPrimaryColor,
                          ),
                          hintText: AppLocalizations.of(context)!
                              .reset_password_view_confirm_new_pass_placeholder_text,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          model.setIsValidConfirmPassword(
                              model.newPassword == model.confirmNewPassword);
                        },
                      ),
                    ),
                    Image.asset(
                      "assets/icons/change.png",
                      width: screenWidth * 0.6,
                      height: screenWidth * 0.8,
                      color: kPrimaryColor,
                    ),
                    const Spacer(),
                    model.resetPasswordProcessing
                        ? SizedBox(
                            width: screenWidth * 0.6,
                            child: const ButtonProgressIndicator())
                        : GestureDetector(
                            onTap: () async {
                              model.setResetPasswordProcessing(true);

                              if (model.newPassword.isEmpty ||
                                  model.resetCode.isEmpty ||
                                  model.confirmNewPassword.isEmpty) {
                                buildInformationSheet(
                                  message: AppLocalizations.of(context)!
                                      .reset_password_view_please_complete_text,
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                );
                                model.setResetPasswordProcessing(false);
                                return;
                              }

                              if (!model.isValidEmail) {
                                buildInformationSheet(
                                  message: AppLocalizations.of(context)!
                                      .please_check_inputs_text,
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                );
                                model.setResetPasswordProcessing(false);
                                return;
                              }

                              if (model.newPassword !=
                                  model.confirmNewPassword) {
                                buildInformationSheet(
                                  message: AppLocalizations.of(context)!
                                      .change_password_view_new_passwords_not_match,
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                );
                                model.setResetPasswordProcessing(false);
                                return;
                              }

                              var response = await model.resetPassword();
                              if ((response!.codeAlreadyUsed) ||
                                  (response.codeDoesNotExist) ||
                                  (response.codeExpired)) {
                                buildInformationSheet(
                                  message: response.message,
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                );
                                model.setResetPasswordProcessing(false);
                                return;
                              }

                              buildInformationSheet(
                                message: response.message,
                                icon: const Icon(
                                  Icons.info,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              );
                              model.setResetPasswordProcessing(false);

                              await Future.delayed(const Duration(seconds: 3));
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/LoginView', (Route route) => false);
                            },
                            child: SizedBox(
                                width: screenWidth * 0.6,
                                child: ClassicButton(
                                    text: AppLocalizations.of(context)!
                                        .reset_password_view_reset_password_text))),
                    const SizedBox(height: 15)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
