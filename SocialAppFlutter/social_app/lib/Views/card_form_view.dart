import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/blocs/blocs.dart';
import 'package:social_app/services/ievents_service.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:social_app/utilities/service_locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CardFormView extends StatefulWidget {
  final int approvedLocationId;
  final String ownerEmail;
  const CardFormView(
      {super.key, required this.approvedLocationId, required this.ownerEmail});

  @override
  State<CardFormView> createState() => _CardFormViewState();
}

class _CardFormViewState extends State<CardFormView> {
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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          CardFormEditController controller = CardFormEditController(
              initialDetails: state.cardFieldInputDetails);
          if (state.status == PaymentStatus.initial) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: const Icon(Icons.close)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.card_form_view_card_details_text,
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  CardFormField(
                    enablePostalCode: false,
                    style: CardFormStyle(
                        borderColor: kPrimaryColor,
                        backgroundColor: kPrimaryColor,
                        textColor: Colors.white,
                        placeholderColor: Colors.white,
                        cursorColor: Colors.white),
                    controller: controller,
                  ),
                  const SizedBox(height: 10),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      controller.details.complete
                          ? context.read<PaymentBloc>().add(PaymentCreateIntent(
                                  billingDetails:
                                      BillingDetails(email: widget.ownerEmail),
                                  items: const [
                                    {'id': 0},
                                    {'id': 1}
                                  ]))
                          : ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(AppLocalizations.of(context)!.card_form_view_incomplete_form_text)));
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
                          AppLocalizations.of(context)!.card_form_view_pay_text,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          if (state.status == PaymentStatus.success) {
            provider
                .get<IEventsService>()
                .confirmNewLocationPayment(widget.approvedLocationId);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.card_form_view_succes),
                const SizedBox(height: 10, width: double.infinity),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/LoginView', (Route route) => false);
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
                        AppLocalizations.of(context)!.card_form_view_got_it,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
          if (state.status == PaymentStatus.failure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.card_form_view_failed),
                const SizedBox(height: 10, width: double.infinity),
                ElevatedButton(
                    onPressed: () {
                      context.read<PaymentBloc>().add(PaymentStart());
                    },
                    child: Text(AppLocalizations.of(context)!.card_form_view_try_again_text))
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
