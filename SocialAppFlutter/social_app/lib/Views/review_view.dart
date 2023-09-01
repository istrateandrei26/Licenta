import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/Models/event_review_info.dart';
import 'package:social_app/ViewModels/review_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ReviewView extends StatefulWidget {
  const ReviewView({super.key, required this.eventReviewInfo});

  final EventReviewInfo eventReviewInfo;

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
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
    return ViewModelBuilder.reactive(
        onModelReady: (model) => model.initialize(),
        viewModelBuilder: () =>
            ReviewViewModel(eventReviewInfo: widget.eventReviewInfo),
        builder: (context, model, child) => GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.5,
                  maxChildSize: 0.7,
                  builder: (_, scrollController) => Stack(children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .review_view_enjoy,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Center(
                                child: RatingBar.builder(
                                  initialRating: model.ratingScore,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    model.setRatingScore(rating);
                                    // print(rating);
                                  },
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      model.eventInfo.sportCategory.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/city.png",
                                      width: 15,
                                      height: 15,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(model.eventInfo.location.city.trim(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/pin.png",
                                      width: 15,
                                      height: 15,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        model.eventInfo.location.locationName
                                            .trim(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/calendar.png",
                                      width: 15,
                                      height: 15,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        formatDate(
                                            model.eventInfo.startDateTime, [
                                          dd,
                                          '-',
                                          mm,
                                          '-',
                                          yyyy,
                                          ' ',
                                          HH,
                                          ':',
                                          nn
                                        ]),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              const Divider(
                                color: Colors.black38,
                              ),
                              const SizedBox(height: 20.0),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .review_view_honor,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Expanded(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: model.eventMembers.length,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      String item =
                                          "${model.eventMembers[index].firstname!} ${model.eventMembers[index].lastname!}";

                                      if (model.selectedUsers.contains(item)) {
                                        model.selectedUsers.remove(item);
                                      } else {
                                        model.selectedUsers.add(item);
                                      }

                                      int memberId =
                                          model.eventMembers[index].id!;

                                      if (model.selectedUsersIds
                                          .contains(memberId)) {
                                        model.selectedUsersIds.remove(memberId);
                                      } else {
                                        model.selectedUsersIds.add(memberId);
                                      }

                                      setState(() {});
                                      print(model.selectedUsers);
                                    },
                                    child: ListTile(
                                      trailing: Visibility(
                                        visible: model.selectedUsers.contains(
                                            "${model.eventMembers[index].firstname} ${model.eventMembers[index].lastname}"),
                                        child: Image.asset(
                                          "assets/icons/medal.png",
                                          width: 15,
                                          height: 15,
                                        ),
                                      ),
                                      title: Text(
                                        "${model.eventMembers[index].firstname!} ${model.eventMembers[index].lastname!}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      leading: model.eventMembers[index]
                                                  .profileImage ==
                                              null
                                          ? CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  Colors.grey.shade700,
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.white,
                                              backgroundImage: MemoryImage(
                                                  Uint8List.fromList(model
                                                      .eventMembers[index]
                                                      .profileImage!)),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () {
                                  model.sendReview();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    minimumSize: const Size.fromHeight(35)),
                                child: Text(AppLocalizations.of(context)!
                                    .review_view_send),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ])),
            ));
  }
}
