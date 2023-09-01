import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/ViewModels/payment_verification_code_view_model.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';

import 'create_event_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentVerificationCodeView extends StatefulWidget {
  const PaymentVerificationCodeView({super.key});

  @override
  State<PaymentVerificationCodeView> createState() =>
      _PaymentVerificationCodeViewState();
}

class _PaymentVerificationCodeViewState
    extends State<PaymentVerificationCodeView> {
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
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => PaymentVerificationCodeViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                ActionPageButton(
                  onTap: () {},
                  canQuit: true,
                  canGoBack: false,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                      AppLocalizations.of(context)!.payment_verif_code_view_text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15)),
                ),
                const SizedBox(height: 10),
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
                    controller: model.verificationCodeController,
                    maxLength: 8,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      counterText: '',
                      icon: Icon(
                        Icons.verified,
                        color: kPrimaryColor,
                      ),
                      hintText: AppLocalizations.of(context)!.payment_verif_code_view_code_placeholder,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                !model.found
                    ? Icon(
                        Icons.safety_check,
                        color: kPrimaryColor,
                        size: screenWidth * 0.8,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                AppLocalizations.of(context)!.payment_verif_code_view_summary_text,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/icons/star.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            model.sportCategory,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/icons/city.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(model.city,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/icons/pin.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(model.locationName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Card(
                                      color: Colors.transparent,
                                      elevation: 20,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: SizedBox(
                                          width: screenWidth * 0.9,
                                          height: screenHeight * 0.3,
                                          child: GoogleMap(
                                            initialCameraPosition: CameraPosition(
                                                target: model
                                                    .selectedLocationCoordinates!,
                                                zoom: model.cameraStandardZoom),
                                            scrollGesturesEnabled: false,
                                            tiltGesturesEnabled: false,
                                            zoomGesturesEnabled: false,
                                            rotateGesturesEnabled: false,
                                            zoomControlsEnabled: false,
                                            markers:
                                                model.mapMarkers.values.toSet(),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const Spacer(),
                model.found
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/CardFormView",
                              arguments: [
                                model.approvedLocationId,
                                model.ownerEmail
                              ]);
                        },
                        child: SizedBox(
                          width: screenWidth * 0.6,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: kDefaultPadding,
                                right: kDefaultPadding,
                                bottom: kDefaultPadding),
                            alignment: Alignment.center,
                            height: kDefaultPadding * 2,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.payment_verif_code_view_pay_text,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (model.verificationCode.isEmpty) {
                            buildInformationSheet(
                                message: AppLocalizations.of(context)!.payment_verif_code_view_please_enter_text,
                                icon: const Icon(Icons.info_outline_rounded));
                            return;
                          }

                          model.setProcessing(true);
                          var response = await model.submitVerificationCode();

                          if (!response!.found) {
                            buildInformationSheet(
                                message: AppLocalizations.of(context)!.payment_verif_code_view_incorrect_code_text,
                                icon: const Icon(Icons.info_outline_rounded));
                          } else if (response.alreadyUsed) {
                            buildInformationSheet(
                                message: AppLocalizations.of(context)!.payment_verif_code_view_already_used_text,
                                icon: const Icon(Icons.info_outline_rounded));
                          } else {
                            buildInformationSheet(
                                message: AppLocalizations.of(context)!.payment_verif_code_view_correct_text,
                                icon: const Icon(Icons.info_outline_rounded));
                            model.setFound(response.found);
                          }

                          model.setProcessing(false);
                        },
                        child: model.processing
                            ? SizedBox(
                                width: screenWidth * 0.6,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: kDefaultPadding,
                                      right: kDefaultPadding,
                                      bottom: kDefaultPadding),
                                  alignment: Alignment.center,
                                  height: kDefaultPadding * 2,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const SizedBox(
                                    height: kDefaultPadding,
                                    width: kDefaultPadding,
                                    child: CircularProgressIndicator.adaptive(
                                      backgroundColor: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: screenWidth * 0.6,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: kDefaultPadding,
                                      right: kDefaultPadding,
                                      bottom: kDefaultPadding),
                                  alignment: Alignment.center,
                                  height: kDefaultPadding * 2,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.payment_verif_code_view_submit_code_text,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
