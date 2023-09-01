import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/ViewModels/change_password_view_model.dart';
import 'package:social_app/components/classic_button.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/button_progress.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ChangePasswordViewModel(),
        builder: (context, model, child) => GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!
                      .change_password_view_change_password_text),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                          child: Icon(
                        Icons.key,
                        color: kPrimaryColor,
                        size: MediaQuery.of(context).size.width * 0.8,
                      )),
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
                          controller: model.oldPasswordController,
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
                                .change_password_view_old_password_placeholder,
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
                          color: model.isValidConfirmPassword
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
                              Icons.lock,
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
                            model.setIsValidConfirmPassword(
                                passwordRegex.hasMatch(value));
                          },
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
                            color: model.passwordsMatch
                              ? Colors.grey[200]
                              : Colors.red[100]),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: model.confirmNewPasswordController,
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
                                .reset_password_view_confirm_new_pass_placeholder_text,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            model.setPasswordsMatch(
                                model.newPassword == model.confirmNewPassword);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          model.setProcessing(true);

                          if (model.oldPassword.isEmpty ||
                              model.newPassword.isEmpty ||
                              model.confirmNewPassword.isEmpty) {
                            buildInformationSheet(
                              message: AppLocalizations.of(context)!
                                  .change_password_view_complete_all_fields,
                              icon: const Icon(
                                Icons.info,
                                size: 50,
                                color: Colors.blue,
                              ),
                            );
                            model.setProcessing(false);
                            return;
                          }

                          if (!model.isValidConfirmPassword) {
                            buildInformationSheet(
                              message: AppLocalizations.of(context)!
                                  .please_check_inputs_text,
                              icon: const Icon(
                                Icons.info,
                                size: 50,
                                color: Colors.blue,
                              ),
                            );
                            model.setProcessing(false);
                            return;
                          }

                          if (model.newPassword != model.confirmNewPassword) {
                            buildInformationSheet(
                              message: AppLocalizations.of(context)!
                                  .change_password_view_new_passwords_not_match,
                              icon: const Icon(
                                Icons.info,
                                size: 50,
                                color: Colors.blue,
                              ),
                            );
                            model.setProcessing(false);
                            return;
                          }

                          var response = await model.changePassword();

                          if (response!.type == Type.invalidOldPassword) {
                            buildInformationSheet(
                              message: AppLocalizations.of(context)!
                                  .change_password_view_wrong_old_password,
                              icon: const Icon(
                                Icons.info,
                                size: 50,
                                color: Colors.blue,
                              ),
                            );
                          } else if (response.type == Type.ok) {
                            buildInformationSheet(
                              message: AppLocalizations.of(context)!
                                  .successfully_changed_password_text,
                              icon: const Icon(
                                Icons.info,
                                size: 50,
                                color: Colors.blue,
                              ),
                            );
                          }

                          model.setProcessing(false);
                        },
                        child: model.processing
                            ? const ButtonProgressIndicator()
                            : ClassicButton(
                                text: AppLocalizations.of(context)!
                                    .change_password_view_change_password_text),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
