import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_app/ViewModels/user_profile_view_model.dart';
import 'package:social_app/components/profile_image_picker.dart';
import 'package:social_app/components/shimmer_widget.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../components/profile_event_card.dart';

class UserProfileView extends StatefulWidget {
  final int userId;
  const UserProfileView({super.key, required this.userId});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
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

  Future buildGalleryImagePickerSheet(UserProfileViewModel model) =>
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          enableDrag: false,
          backgroundColor: Colors.white,
          context: context,
          builder: (context) => Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              height: MediaQuery.of(context).size.height * 0.8,
              child: ProfileImagePicker(handler: (image, userId) async {
                await model.changeProfileImage(image, userId);
              })));

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => UserProfileViewModel(),
        onModelReady: (model) => model.initialize(widget.userId),
        builder: (context, model, child) => (model.processing)
            ? Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200))),
                    child: AppBar(
                        actions: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, "/SettingsView"),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.settings),
                            ),
                          )
                        ],
                        backgroundColor: kPrimaryColor,
                        centerTitle: false,
                        title: const ShimmerWidget.rectangular(
                          height: 15,
                          width: 150,
                        )),
                  ),
                ),
                body: DefaultTabController(
                    length: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18.0, bottom: 10),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onLongPress: () {},
                                    child: const ShimmerWidget.circular(
                                        width: 80, height: 80)),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        const ShimmerWidget.rectangular(
                                            height: 10, width: 20),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: ShimmerWidget.rectangular(
                                              height: 10, width: 50),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        const ShimmerWidget.rectangular(
                                            height: 10, width: 20),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: ShimmerWidget.rectangular(
                                              height: 10, width: 50),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        const ShimmerWidget.rectangular(
                                            height: 10, width: 20),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: ShimmerWidget.rectangular(
                                              height: 10, width: 50),
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(width: 15)
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 7,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const ShimmerWidget.circular(
                                          width: 60, height: 60))),
                            ),
                            const SizedBox(height: 20),
                            Theme(
                              data: ThemeData(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                              child: Material(
                                  color: Colors.white,
                                  child: const SizedBox.shrink()),
                            ),
                            Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ShimmerWidget.rectangular(
                                    height: 30,
                                    width: 70,
                                  ),
                                  ShimmerWidget.rectangular(
                                    height: 30,
                                    width: 70,
                                  ),
                                  ShimmerWidget.rectangular(
                                    height: 30,
                                    width: 70,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: TabBarView(children: [
                              ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: 5,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Card(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  ShimmerWidget.rectangular(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      height: 10),
                                                  const SizedBox(height: 5),
                                                  ShimmerWidget.rectangular(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      height: 10),
                                                  const SizedBox(height: 5),
                                                  ShimmerWidget.rectangular(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      height: 10),
                                                  const SizedBox(height: 5),
                                                  ShimmerWidget.rectangular(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      height: 10),
                                                  const SizedBox(height: 5),
                                                  ShimmerWidget.rectangular(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      height: 10),
                                                ],
                                              ),
                                              const Spacer(),
                                              const ShimmerWidget.circular(
                                                height: 30,
                                                width: 30,
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                            ]))
                          ],
                        ),
                      ),
                    )),
              )
            : Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200))),
                    child: AppBar(
                      actions: [
                        model.user != null && !(model.user!.id != ProfileService.userId)
                            ? GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, "/SettingsView"),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.settings),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                      backgroundColor: kPrimaryColor,
                      centerTitle: false,
                      title: model.user!.id == ProfileService.userId!
                          ? Text(
                              "${ProfileService.firstname} ${ProfileService.lastname}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )
                          : Text(
                              "${model.user!.firstname} ${model.user!.lastname}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ),
                body: DefaultTabController(
                    length: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18.0, bottom: 10),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onLongPress: () =>
                                      buildGalleryImagePickerSheet(model),
                                  child: model.user!.profileImage == null
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.grey.shade700,
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 40.0,
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 40,
                                          backgroundImage: MemoryImage(
                                              Uint8List.fromList(
                                                  model.user!.profileImage!)),
                                        ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          model.eventsAttended.length
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .profile_view_attended_text,
                                          style: TextStyle(
                                              fontSize: 10, letterSpacing: 0.4),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          model.admirers.length.toString(),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .profile_view_honored_by_text,
                                          style: TextStyle(
                                              fontSize: 10, letterSpacing: 0.4),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          model.givenHonors.toString(),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .profile_view_honored_text,
                                          style: TextStyle(
                                              fontSize: 10, letterSpacing: 0.4),
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(width: 15)
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // Edit Profile Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: model.user!.id ==
                                            ProfileService.userId
                                        ? SizedBox.shrink()
                                        : (!model.isFriend! &&
                                                !model.friendRequestSent)
                                            ? OutlinedButton(
                                                onPressed: () => model.sendFriendRequest(ProfileService.userId!, model.user!.id!),
                                                style: OutlinedButton.styleFrom(
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    minimumSize:
                                                        const Size(0, 30),
                                                    backgroundColor:
                                                        kPrimaryColor,
                                                    side: BorderSide(
                                                        color: Colors
                                                            .grey.shade500)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 50),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .profile_view_add_friend_text,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              )
                                            : (!model.isFriend! &&
                                                    model.friendRequestSent)
                                                ? OutlinedButton(
                                                    onPressed: () {},
                                                    style: OutlinedButton.styleFrom(
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            Colors.grey[400],
                                                        minimumSize:
                                                            const Size(0, 30),
                                                        side: BorderSide(
                                                            color: Colors.grey
                                                                .shade500)),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 50),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .profile_view_sent_friend_request_text,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink())
                              ],
                            ),
                            model.attendedCategories.isEmpty
                                ? Text(
                                    AppLocalizations.of(context)!
                                        .profile_view_not_attended_events_text,
                                    style: TextStyle(fontSize: 12),
                                  )
                                : SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            model.attendedCategories.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Stack(children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      Colors.blue.shade200,
                                                  child: Image.asset(
                                                    "${model.attendedCategories[index].sportCategory.image.replaceFirst('/event_card_images', '').replaceFirst("images", "icons").split(".")[0]}.png",
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Image.asset(
                                                      model
                                                                  .attendedCategories[
                                                                      index]
                                                                  .honors >
                                                              3
                                                          ? "assets/icons/gold.png"
                                                          : model.attendedCategories[index].honors >
                                                                      1 &&
                                                                  model.attendedCategories[index]
                                                                          .honors <
                                                                      4
                                                              ? "assets/icons/silver.png"
                                                              : "assets/icons/bronze.png",
                                                      width: 15,
                                                      height: 15,
                                                    )),
                                              ]),
                                            )),
                                  ),
                            const SizedBox(height: 20),
                            Theme(
                              data: ThemeData(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                              child: Material(
                                color: Colors.white,
                                child: TabBar(
                                  labelColor:
                                      const Color.fromARGB(255, 20, 79, 128),
                                  unselectedLabelColor: Colors.grey[400],
                                  indicatorWeight: 1,
                                  indicatorColor:
                                      const Color.fromARGB(255, 20, 79, 128),
                                  tabs: [
                                    Tab(
                                      icon: ImageIcon(
                                        AssetImage("assets/icons/attended.png"),
                                        size: 18,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .profile_view_attended_text,
                                        style: TextStyle(
                                            fontSize:
                                                10.0), // modify font size here
                                      ),
                                    ),
                                    Tab(
                                      icon: ImageIcon(
                                        AssetImage("assets/icons/schedule.png"),
                                        size: 18,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .profile_view_organized_text,
                                        style: TextStyle(
                                            fontSize:
                                                10.0), // modify font size here
                                      ),
                                    ),
                                    Tab(
                                      icon: ImageIcon(
                                        AssetImage(
                                            "assets/icons/medal-ribbon.png"),
                                        size: 18,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .profile_view_admirers_text,
                                        style: TextStyle(
                                            fontSize:
                                                10.0), // modify font size here
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: TabBarView(children: [
                              model.eventsAttended.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .profile_view_no_attended_events_text,
                                            style: TextStyle(fontSize: 15)),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          Icons.stadium_outlined,
                                          color: kPrimaryColor,
                                          size: 100,
                                        )
                                      ],
                                    )
                                  : ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: model.eventsAttended.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          ProfileEventCard(
                                            locationName: model
                                                .eventsAttended[index]
                                                .event
                                                .location
                                                .locationName
                                                .trim(),
                                            city: model.eventsAttended[index]
                                                .event.location.city
                                                .trim(),
                                            datetime: model
                                                .eventsAttended[index]
                                                .event
                                                .startDateTime,
                                            duration: model
                                                .eventsAttended[index]
                                                .event
                                                .duration,
                                            average: -1,
                                            sportCategory: model
                                                .eventsAttended[index]
                                                .event
                                                .sportCategory
                                                .name,
                                            members: model
                                                .eventsAttended[index].members,
                                          )),
                              model.myOwnEvents.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .profile_view_no_organized_events_text,
                                            style: TextStyle(fontSize: 15)),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          Icons.touch_app_outlined,
                                          color: kPrimaryColor,
                                          size: 100,
                                        )
                                      ],
                                    )
                                  : ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: model.myOwnEvents.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          ProfileEventCard(
                                            locationName: model
                                                .myOwnEvents[index]
                                                .event
                                                .location
                                                .locationName
                                                .trim(),
                                            city: model.myOwnEvents[index].event
                                                .location.city
                                                .trim(),
                                            datetime: model.myOwnEvents[index]
                                                .event.startDateTime,
                                            duration: model.myOwnEvents[index]
                                                .event.duration,
                                            average: model.myOwnEvents[index]
                                                .ratingAverage,
                                            sportCategory: model
                                                .myOwnEvents[index]
                                                .event
                                                .sportCategory
                                                .name,
                                            members: model
                                                .myOwnEvents[index].members,
                                          )),
                              model.admirers.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .profile_view_no_admirers_text,
                                            style: TextStyle(fontSize: 15)),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          Icons.leaderboard_outlined,
                                          color: kPrimaryColor,
                                          size: 100,
                                        )
                                      ],
                                    )
                                  : ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: model.admirers.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) => ListTile(
                                        leading: model.admirers[index]
                                                    .profileImage ==
                                                null
                                            ? CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.grey.shade700,
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white,
                                                backgroundImage: MemoryImage(
                                                    Uint8List.fromList(model
                                                        .admirers[index]
                                                        .profileImage!)),
                                              ),
                                        title: Text(
                                            "${model.admirers[index].firstname} ${model.admirers[index].lastname}",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                    ),
                            ]))
                          ],
                        ),
                      ),
                    )),
              ));
  }
}
