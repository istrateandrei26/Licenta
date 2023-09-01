import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/ViewModels/request_new_location_view_model.dart';
import 'package:social_app/components/sport_icons_list.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';

import '../utilities/sport_category_interpreter.dart';
import 'create_event_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestNewLocationView extends StatefulWidget {
  const RequestNewLocationView({super.key});

  @override
  State<RequestNewLocationView> createState() => _RequestNewLocationViewState();
}

class _RequestNewLocationViewState extends State<RequestNewLocationView> {
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

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder.reactive(
        viewModelBuilder: () => RequestNewLocationViewModel(),
        onModelReady: (model) => model.initialize(),
        builder: (context, model, child) => model.processing
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            : GestureDetector(
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
                                hintText: AppLocalizations.of(context)!
                                    .request_new_location_view_email_text,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onChanged: (value) {
                                model.setIsValidEmail(
                                    EmailValidator.validate(value));
                              }),
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
                            controller: model.cityController,
                            maxLength: 20,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              counterText: '',
                              icon: Icon(
                                Icons.location_city,
                                color: kPrimaryColor,
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .request_new_location_view_city_text,
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
                            controller: model.locationNameController,
                            maxLength: 35,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              counterText: '',
                              icon: Icon(
                                Icons.location_on,
                                color: kPrimaryColor,
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .request_new_location_view_location_name_text,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Card(
                            color: Colors.transparent,
                            elevation: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                  width: screenWidth * 0.9,
                                  height: screenHeight * 0.3,
                                  child: GoogleMap(
                                      markers: model.mapMarkers.values.toSet(),
                                      onCameraMove: (CameraPosition position) {
                                        setState(() {
                                          model.mapMarkers['pickMarker'] = model
                                              .mapMarkers['pickMarker']!
                                              .copyWith(
                                            positionParam: position.target,
                                          );
                                          // print("${position.zoom}");
                                          // print(
                                          //     "${model.mapMarkers['pickMarker']!.position.latitude},${model.mapMarkers['pickMarker']!.position.longitude}");
                                        });
                                      },
                                      zoomControlsEnabled: false,
                                      initialCameraPosition:
                                          const CameraPosition(
                                              target: LatLng(45.77774230529796,
                                                  24.797969833016396),
                                              zoom: 5.788174629211426))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: RotatedBox(
                              quarterTurns: -1,
                              child: Swiper(
                                index: model.lastSelectedCategoryIndex,
                                onIndexChanged: (value) {
                                  model.setSelectedCategory(
                                      SportCategoryInterpreter
                                          .createSportCategoryByIndex(value));

                                  model.setLastSelectedCategoryIndex(value);
                                },
                                itemCount: icon_list.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) =>
                                    icon_list[index],
                                viewportFraction: 0.3,
                                scale: 0.1,
                              )),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () async {
                              if (model.email.isEmpty ||
                                  model.city.isEmpty ||
                                  model.locationName.isEmpty) {
                                buildInformationSheet(
                                    message: AppLocalizations.of(context)!
                                        .request_new_location_view_please_fill_fields_text,
                                    icon:
                                        const Icon(Icons.info_outline_rounded));
                                return;
                              }

                              if(!model.isValidEmail) {
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

                              model.setSubmittingNewLocationRequest(true);
                              var response =
                                  await model.submitNewLocationRequest();

                              if (response!.success) {
                                await buildInformationSheet(
                                    message: AppLocalizations.of(context)!
                                        .request_new_location_view_successfully_text,
                                    icon:
                                        const Icon(Icons.info_outline_rounded));
                                await Future.delayed(
                                    const Duration(seconds: 3));

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/LoginView', (Route route) => false);
                              } else {
                                buildInformationSheet(
                                    message: AppLocalizations.of(context)!
                                        .request_new_location_view_wrong_text,
                                    icon:
                                        const Icon(Icons.info_outline_rounded));
                              }

                              model.setSubmittingNewLocationRequest(false);
                            },
                            child: model.submittingNewLocationRequest
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
                                        child:
                                            CircularProgressIndicator.adaptive(
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
                                        AppLocalizations.of(context)!
                                            .request_new_location_view_submit_text,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
