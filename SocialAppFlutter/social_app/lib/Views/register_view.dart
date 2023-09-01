import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_app/Models/auth/basic_response.dart';
import 'package:social_app/ViewModels/register_view_model.dart';
import 'package:social_app/Views/login_view.dart';
import 'package:social_app/components/button_progress.dart';
import 'package:stacked/stacked.dart';
import '../components/register_button.dart';
import '../utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:email_validator/email_validator.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  getConnectivity() =>
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

    return ViewModelBuilder.reactive(
        viewModelBuilder: () => RegisterViewModel(),
        builder: (context, model, child) => GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.35,
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
                                child:
                                    Image.asset("assets/images/logo_image.png"),
                              ),
                            ],
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
                          color: model.isValidUsername
                              ? Colors.grey[200]
                              : Colors.red[100],
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
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            final regex = RegExp(
                                r'^(?=.{5,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$');

                            model.setIsValidUsername(regex.hasMatch(value));
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
                          color: model.isValidEmail
                              ? Colors.grey[200]
                              : Colors.red[100],
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: model.emailController,
                          maxLength: 35,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                            counterText: '',
                            icon: Icon(
                              Icons.email,
                              color: kPrimaryColor,
                            ),
                            hintText: AppLocalizations.of(context)!.email_text,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            model.setIsValidEmail(
                                EmailValidator.validate(value));
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
                          color: model.isValidFirstname
                              ? Colors.grey[200]
                              : Colors.red[100],
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: model.firstnameController,
                          maxLength: 20,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                            counterText: '',
                            icon: Icon(
                              Icons.person_pin,
                              color: kPrimaryColor,
                            ),
                            hintText:
                                AppLocalizations.of(context)!.firstname_text,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            final firstNameRegex = RegExp(
                                r"^[A-Z][A-Za-z]*(?:(?![' -])[' -](?![' -]))?[A-Za-z]+$");
                            model.setIsValidFirstname(
                                firstNameRegex.hasMatch(value));
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
                          color: model.isValidLastname
                              ? Colors.grey[200]
                              : Colors.red[100],
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: model.lastnameController,
                          maxLength: 20,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                            counterText: '',
                            icon: Icon(
                              Icons.person_pin,
                              color: kPrimaryColor,
                            ),
                            hintText:
                                AppLocalizations.of(context)!.lastname_text,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            final lastNameRegex = RegExp(
                                r"^[A-Z][A-Za-z]*(?:(?![' -])[' -](?![' -]))?[A-Za-z]+$");
                            model.setIsValidLastname(
                                lastNameRegex.hasMatch(value));
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
                          color: model.isValidPassword
                              ? Colors.grey[200]
                              : Colors.red[100],
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
                          controller: model.confirmPasswordController,
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
                                .confirm_password_text_placeholder,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            model.setIsValidConfirmPassword(
                                model.password == model.confirmPassword);
                          },
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            if (model.username.isEmpty ||
                                model.email.isEmpty ||
                                model.firstname.isEmpty ||
                                model.lastname.isEmpty ||
                                model.password.isEmpty ||
                                model.confirmPassword.isEmpty) {

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

                            if(!model.isValidUsername || !model.isValidEmail || !model.isValidFirstname || !model.isValidLastname || !model.isValidPassword) {
                              buildInformationSheet(
                                message: AppLocalizations.of(context)!
                                    .please_check_inputs_text,
                                icon: const Icon(
                                  Icons.info,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              );
                              return;
                            }

                            if (model.password != model.confirmPassword) {
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

                            var response = await model.register();
                            if (response?.type == Type.existingEmail) {
                              buildInformationSheet(
                                message: AppLocalizations.of(context)!
                                    .email_already_in_use_text,
                                icon: const Icon(
                                  Icons.info,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              );
                            } else if (response?.type ==
                                Type.existingUsername) {
                              buildInformationSheet(
                                message: AppLocalizations.of(context)!
                                    .username_already_in_user_text,
                                icon: const Icon(
                                  Icons.info,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              );
                            } else if (response?.statusCode == 200) {
                              buildInformationSheet(
                                message: AppLocalizations.of(context)!
                                    .successfully_registered_text,
                                icon: const Icon(
                                  Icons.info,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              );
                            } else {
                              buildInformationSheet(
                                message: response!.message,
                                icon: const Icon(
                                  Icons.info,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              );
                            }
                          },
                          child: model.processing
                              ? const ButtonProgressIndicator()
                              : RegisterButton(
                                  text: AppLocalizations.of(context)!
                                      .register_text)),
                      Container(
                        margin: const EdgeInsets.only(top: kDefaultPadding / 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!
                                    .already_a_member_text +
                                " "),
                            GestureDetector(
                              onTap: (() => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginView()))
                                  }),
                              child: Text(
                                AppLocalizations.of(context)!.login_text,
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
