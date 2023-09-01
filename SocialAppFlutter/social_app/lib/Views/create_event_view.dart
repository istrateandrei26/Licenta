import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/ViewModels/create_event_view_model.dart';
import 'package:social_app/components/duration_list.dart';
import 'package:social_app/components/progress_button.dart';
import 'package:social_app/components/progress_button_loading.dart';
import 'package:social_app/components/progress_loading_button.dart';
import 'package:social_app/components/sport_icons_list.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:social_app/utilities/sport_category_interpreter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Models/place_autocomplete_suggestion.dart';
import '../components/location_list_tile.dart';
import '../services/google_place_service.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  PageController pageController = PageController(initialPage: 0);
  final ScrollController _icon_list_controller =
      ScrollController(initialScrollOffset: 320);
  final FixedExtentScrollController _location_list_controller =
      FixedExtentScrollController();
  final FixedExtentScrollController _city_list_controller =
      FixedExtentScrollController();

  final FixedExtentScrollController _testController =
      FixedExtentScrollController(
          initialItem: 1 /*model.lastSelectedCityIndex*/);
  final TextEditingController _searchFriendController = TextEditingController();

  DateTime _selectedDatetime = DateTime.now().add(
    Duration(minutes: 90 - DateTime.now().minute % 30),
  );
  DateTime _initialDatetime = DateTime.now().add(
    Duration(minutes: 90 - DateTime.now().minute % 30),
  );

  //Google Map requirements:
  final _searchLocationFieldController = TextEditingController();
  List<PlaceAutocompleteSuggestion> placeSuggestions = [];

  //navigation to and from map view requirements:
  bool came_from_city_choice = false;
  bool came_from_location_choice = false;
  bool _cameraMoving = false;

  //internet checkings

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
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            )),
      );

  void placeAutocomplete(String query) async {
    var suggestions =
        await GooglePlaceService.fetchAutocompleteSuggestions(query);

    placeSuggestions = suggestions;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CreateEventViewModel(),
        onModelReady: (model) => model.initializeUserLocation(),
        disposeViewModel: true,
        builder: (context, model, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: SafeArea(
                child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child:
                                  Image.asset("assets/images/competition.png")),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_event_creator_text,
                                  style: kTitleStyle.copyWith(fontSize: 22),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_outreach,
                                  style: kSubtitleStyle.copyWith(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                ProgressButton(
                                  onNext: nextPage,
                                  isAnimated: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ActionPageButton(
                            onTap: previousPage,
                            canQuit: true,
                            canGoBack: false,
                          ),
                          Image.asset("assets/images/running.png"),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                    AppLocalizations.of(context)!
                                        .create_event_view_choose_category,
                                    style: kTitleStyle.copyWith(fontSize: 22)),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_enjoy_category,
                                  style: kSubtitleStyle.copyWith(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                width: double.infinity,
                                height: 100,
                                child: RotatedBox(
                                    quarterTurns: -1,
                                    child: Swiper(
                                      index: model.lastSelectedCategoryIndex,
                                      onIndexChanged: (value) {
                                        model.setSelectedCategory(
                                            SportCategoryInterpreter
                                                .createSportCategoryByIndex(
                                                    value));

                                        model.setLastSelectedCategoryIndex(
                                            value);
                                        // model.initialize();
                                      },
                                      itemCount: icon_list.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) =>
                                          icon_list[index],
                                      viewportFraction: 0.3,
                                      scale: 0.1,
                                    )),
                              ),
                            ),
                          ),
                          model.loadingInfoByCategoryId
                              ? ProgressButtonLoading(
                                  onNext: () {}, isAnimated: false)
                              : ProgressButton(
                                  onNext: () async {
                                    model.setLoadingInfoByCategoryId(true);

                                    await model.initializeInfoBySportCategory();

                                    nextPage();
                                    model.setLoadingInfoByCategoryId(false);
                                  },
                                  isAnimated: false,
                                ),
                          const SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ActionPageButton(
                            onTap: previousPage,
                            canQuit: true,
                            canGoBack: true,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              came_from_city_choice = true;
                              came_from_location_choice = false;
                              chooseMapLocationPage();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .create_event_view_desired_city,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Image.asset("assets/images/map.png",
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.3),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              children: [
                                Text(
                                    AppLocalizations.of(context)!
                                        .create_event_view_choose_city,
                                    style: kTitleStyle.copyWith(fontSize: 22)),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    AppLocalizations.of(context)!
                                        .create_event_view_enjoy_wherever,
                                    style:
                                        kSubtitleStyle.copyWith(fontSize: 18)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                  height: 300,
                                  child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                    onNotification: (overscroll) {
                                      overscroll.disallowIndicator();
                                      return true;
                                    },
                                    child: CupertinoPicker(
                                        scrollController: FixedExtentScrollController(initialItem: model.lastSelectedCityIndex),
                                        itemExtent: 64,
                                        diameterRatio: 10.1,
                                        looping: false,
                                        onSelectedItemChanged: (value) {
                                          model.setLastSelectedCityIndex(value);
                                          model.setSelectedCity(
                                              model.availableCities[value]);

                                          model.setAvailableChosenLocations(model
                                              .availableLocations
                                              .where((element) =>
                                                  element.city ==
                                                  model.selectedCity)
                                              .toList());
                                          model.setSelectedLocation(model
                                              .availableChosenLocations.first);

                                          model.setLastSelectedLocationIndex(value);
                                        },
                                        selectionOverlay:
                                            CupertinoPickerDefaultSelectionOverlay(
                                          background:
                                              Colors.blue.withOpacity(0.12),
                                        ),
                                        children: 
                                        model.availableCities
                                            .map((e) => Center(
                                                  child: Text(
                                                    e,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ))
                                            .toList(),
                                        ),
                                  )),
                            ),
                          ),
                          ProgressButton(
                            onNext: () {
                              setState(() {
                                model.locationSelectedByMap = false;
                              });
                              nextPage();
                            },
                            isAnimated: false,
                          ),
                          const SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ActionPageButton(
                            onTap: previousPage,
                            canQuit: true,
                            canGoBack: true,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              came_from_city_choice = false;
                              came_from_location_choice = true;
                              chooseMapLocationPage();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor),
                            child: Text(
                                AppLocalizations.of(context)!
                                    .create_event_view_desired_location,
                                style: TextStyle(fontSize: 10)),
                          ),
                          Image.asset("assets/images/location.png",
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.4),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                    AppLocalizations.of(context)!
                                        .create_event_view_choose_location,
                                    style: kTitleStyle.copyWith(fontSize: 22)),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                    AppLocalizations.of(context)!
                                        .create_event_view_enjoy_wherever,
                                    style:
                                        kSubtitleStyle.copyWith(fontSize: 18)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                  height: 300,
                                  child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                    onNotification: (overscroll) {
                                      overscroll.disallowIndicator();
                                      return true;
                                    },
                                    child: CupertinoPicker(
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: model
                                                  .lastSelectedLocationIndex),
                                      itemExtent: 64,
                                      diameterRatio: 10.1,
                                      looping: false,
                                      onSelectedItemChanged: (value) {
                                        model.setLastSelectedLocationIndex(
                                            value);
                                        model.setSelectedLocation(model
                                            .availableChosenLocations[value]);
                                        model.setLastSelectedLocationIndex(
                                            value);
                                      },
                                      selectionOverlay:
                                          CupertinoPickerDefaultSelectionOverlay(
                                        background:
                                            Colors.blue.withOpacity(0.12),
                                      ),
                                      children: model.availableChosenLocations
                                          .map((e) => Center(
                                                child: Text(
                                                  e.locationName.trim(),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  )),
                            ),
                          ),
                          ProgressButton(
                            onNext: () {
                              setState(() {
                                model.locationSelectedByMap = false;
                              });
                              chooseTimePage();
                            },
                            isAnimated: false,
                          ),
                          const SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ActionPageButton(
                            onTap: () {
                              chooseCategoryPage();
                            },
                            canQuit: true,
                            canGoBack: true,
                          ),
                          const SizedBox(height: 10.0),
                          model.loadingUserLocation
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                    ),
                                    Container(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator
                                            .adaptive()),
                                    SizedBox(height: 10),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .create_event_view_map_loading,
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                )
                              : Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Card(
                                      elevation: 20,
                                      color: Colors.transparent,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Stack(children: [
                                            GoogleMap(
                                              markers: model.mapMarkers.values
                                                  .toSet(),
                                              zoomControlsEnabled: false,
                                              myLocationButtonEnabled: false,
                                              zoomGesturesEnabled:
                                                  placeSuggestions.isEmpty,
                                              onMapCreated: (controller) {
                                                model.controller = controller;
                                                model.controller
                                                    ?.getVisibleRegion();
                                              },
                                              onCameraMoveStarted: () {
                                                _cameraMoving = true;
                                              },
                                              onCameraIdle: () {
                                                if (_cameraMoving) {
                                                  model.onCameraIdle();

                                                  _cameraMoving = false;
                                                }
                                              },
                                              onCameraMove:
                                                  (CameraPosition position) {
                                                setState(() {
                                                  model.mapMarkers[
                                                          'pickMarker'] =
                                                      model.mapMarkers[
                                                              'pickMarker']!
                                                          .copyWith(
                                                    positionParam:
                                                        position.target,
                                                  );
                                                  // print(
                                                  //     "${model.mapMarkers['pickMarker']!.position.latitude},${model.mapMarkers['pickMarker']!.position.longitude}");
                                                });
                                              },
                                              myLocationEnabled: true,
                                              initialCameraPosition:
                                                  CameraPosition(
                                                      target: LatLng(
                                                          model.userLocation!
                                                              .latitude,
                                                          model.userLocation!
                                                              .longitude),
                                                      zoom: 11.18),
                                            ),
                                            Positioned(
                                              bottom: 20,
                                              right: 20,
                                              child: FloatingActionButton(
                                                backgroundColor:
                                                    Colors.blue.shade100,
                                                onPressed: model
                                                        .updatingLiveLocation
                                                    ? () {}
                                                    : model.goToCurrentLocation,
                                                child: model
                                                        .updatingLiveLocation
                                                    ? SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            const CircularProgressIndicator
                                                                .adaptive(
                                                          strokeWidth: 2,
                                                        ))
                                                    : const Icon(
                                                        Icons.location_on,
                                                        color: kPrimaryColor,
                                                      ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 5,
                                              left: 10,
                                              right: 10,
                                              child: Column(
                                                children: [
                                                  Form(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      child: Card(
                                                        elevation: 10,
                                                        color:
                                                            Colors.transparent,
                                                        child: TextFormField(
                                                          controller:
                                                              _searchLocationFieldController,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              placeAutocomplete(
                                                                  value);
                                                            });

                                                            if (value.isEmpty) {
                                                              setState(() {
                                                                placeSuggestions
                                                                    .clear();
                                                              });
                                                            }
                                                          },
                                                          textInputAction:
                                                              TextInputAction
                                                                  .search,
                                                          cursorColor:
                                                              kPrimaryColor,
                                                          decoration:
                                                              InputDecoration(
                                                                  filled: true,
                                                                  fillColor: Colors
                                                                      .blue
                                                                      .shade100,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        style: BorderStyle
                                                                            .none,
                                                                        width:
                                                                            0),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  hintText: AppLocalizations.of(
                                                                          context)!
                                                                      .create_event_view_search_location,
                                                                  suffixIcon:
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                            setState(() {
                                                                              placeSuggestions.clear();
                                                                              _searchLocationFieldController.clear();
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons.close,
                                                                            color:
                                                                                kPrimaryColor,
                                                                          )),
                                                                  prefixIcon:
                                                                      const Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            12),
                                                                    child: Icon(
                                                                      Icons
                                                                          .location_on_outlined,
                                                                      color:
                                                                          kPrimaryColor,
                                                                    ),
                                                                  )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: placeSuggestions
                                                        .isNotEmpty,
                                                    child: Container(
                                                      color: placeSuggestions
                                                              .isEmpty
                                                          ? Colors.transparent
                                                          : Colors.white,
                                                      height: 200,
                                                      child: ListView.builder(
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        itemCount:
                                                            placeSuggestions
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                InkWell(
                                                          onTap: () async {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            var location = await GooglePlaceService
                                                                .fetchLocation(
                                                                    placeSuggestions[
                                                                            index]
                                                                        .placeId);
                                                            setState(() {
                                                              placeSuggestions
                                                                  .clear();
                                                            });
                                                            model.controller
                                                                ?.animateCamera(
                                                                    CameraUpdate
                                                                        .newCameraPosition(
                                                              CameraPosition(
                                                                bearing: 0,
                                                                target: LatLng(
                                                                    location
                                                                        .lat,
                                                                    location
                                                                        .lng),
                                                                zoom: 15.0,
                                                              ),
                                                            ));
                                                          },
                                                          child: LocationListTile(
                                                              location:
                                                                  placeSuggestions[
                                                                          index]
                                                                      .description),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ])),
                                    ),
                                  ),
                                ),
                          if (model.loadingUserLocation) Spacer(),
                          const SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: !model.loadingUserLocation,
                            child: ProgressButton(
                              onNext: () async {
                                await model.setMapCityAndStreet();
                                setState(() {
                                  model.locationSelectedByMap = true;
                                });
                                nextPage();
                              },
                              isAnimated: false,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ActionPageButton(
                            onTap: model.locationSelectedByMap
                                ? chooseMapLocationPage
                                : chooseCityPage,
                            canQuit: true,
                            canGoBack: true,
                          ),
                          Image.asset("assets/images/calendar.png"),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_choose_time,
                                  style: kTitleStyle.copyWith(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_enjoy_time,
                                  style: kSubtitleStyle.copyWith(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 180,
                                  child: CupertinoDatePicker(
                                    minuteInterval: 30,
                                    minimumDate: _initialDatetime,
                                    initialDateTime: _initialDatetime,
                                    maximumDate: DateTime(
                                        _initialDatetime.year,
                                        _initialDatetime.month + 1,
                                        _initialDatetime.day),
                                    mode: CupertinoDatePickerMode.dateAndTime,
                                    use24hFormat: true,
                                    onDateTimeChanged: (value) => setState(
                                      () {
                                        _selectedDatetime = value;
                                        model.setSelectedDatetime(value);
                                      },
                                    ),
                                  )),
                            ),
                          ),
                          ProgressButton(
                            onNext: nextPage,
                            isAnimated: false,
                          ),
                          const SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ActionPageButton(
                            onTap: previousPage,
                            canQuit: true,
                            canGoBack: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Image.asset("assets/images/hourglass.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_choose_duration,
                                  style: kTitleStyle.copyWith(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_enjoy_duration,
                                  style: kSubtitleStyle.copyWith(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                  child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                onNotification: (overscroll) {
                                  overscroll.disallowIndicator();
                                  return true;
                                },
                                child: CupertinoPicker(
                                    itemExtent: 64,
                                    diameterRatio: 1.1,
                                    looping: false,
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: model
                                                .lastSelectedDurationIndex),
                                    onSelectedItemChanged: (value) {
                                      model.setLastSelectedDurationIndex(value);
                                      model.setDuration(
                                          duration_list[value].minutes);
                                    },
                                    selectionOverlay:
                                        CupertinoPickerDefaultSelectionOverlay(
                                      background: Colors.blue.withOpacity(0.12),
                                    ),
                                    children: duration_list),
                              )),
                            ),
                          ),
                          ProgressButton(
                            onNext: nextPage,
                            isAnimated: false,
                          ),
                          const SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ActionPageButton(
                            onTap: previousPage,
                            canQuit: true,
                            canGoBack: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Image.asset("assets/images/third-party.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_choose_team,
                                  style: kTitleStyle.copyWith(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_enjoy_team,
                                  style: kSubtitleStyle.copyWith(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                  child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                onNotification: (overscroll) {
                                  overscroll.disallowIndicator();
                                  return true;
                                },
                                child: CupertinoPicker(
                                    itemExtent: 64,
                                    diameterRatio: 1.1,
                                    looping: false,
                                    scrollController: FixedExtentScrollController(
                                        initialItem: model
                                            .lastSelectedRequiredMembersIndex),
                                    onSelectedItemChanged: (value) {
                                      model.setLastSelectedRequiredMembersIndex(
                                          value);
                                      model.setSelectedRequiredMembers(icon_list
                                          .firstWhere((element) =>
                                              element.id ==
                                              model.selectedCategory.id)
                                          .requiredMembers[value]);
                                    },
                                    selectionOverlay:
                                        CupertinoPickerDefaultSelectionOverlay(
                                      background: Colors.blue.withOpacity(0.12),
                                    ),
                                    children: icon_list[
                                            model.lastSelectedCategoryIndex]
                                        .requiredMembers
                                        .map((e) => Center(
                                              child: Text(
                                                "$e",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ))
                                        .toList()),
                              )),
                            ),
                          ),
                          ProgressButton(
                            onNext: nextPage,
                            isAnimated: false,
                          ),
                          const SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ActionPageButton(
                              onTap: () {
                                model.clearSelectedUsers();
                                previousPage();
                              },
                              canQuit: true,
                              canGoBack: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .create_event_view_add_some_friends,
                                    style: kTitleStyle.copyWith(fontSize: 22),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .create_event_view_enjoy_team,
                                    style:
                                        kSubtitleStyle.copyWith(fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "${model.selectedUsersIds.length + 1} / ${model.selectedRequiredMembers}"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (model.selectedUsersIds.length + 1 ==
                                      model.selectedRequiredMembers)
                                    Icon(
                                      Icons.check,
                                      color: Colors.green.shade800,
                                      size: 16,
                                    )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              model.setFriendListOnSearch(model
                                                  .friendList
                                                  .where((element) =>
                                                      "${element.firstname} ${element.lastname}"
                                                          .toLowerCase()
                                                          .contains(value
                                                              .toLowerCase()))
                                                  .toList());
                                            });
                                          },
                                          controller: _searchFriendController,
                                          maxLength: 40,
                                          decoration: InputDecoration(
                                              counterText: '',
                                              border: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.all(15),
                                              hintText: AppLocalizations.of(
                                                      context)!
                                                  .create_event_view_search_text),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            model.friendListOnSearch.clear();
                                            _searchFriendController.clear();
                                          });
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: kPrimaryColor.withOpacity(0.3),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            _searchFriendController.text.isNotEmpty &&
                                    model.friendListOnSearch.isEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                    itemCount: 1,
                                    itemBuilder: (context, index) => ListTile(
                                      title: Center(
                                          child: Text(AppLocalizations.of(
                                                  context)!
                                              .create_event_view_no_results)),
                                    ),
                                  ))
                                : Expanded(
                                    child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount:
                                        _searchFriendController.text.isNotEmpty
                                            ? model.friendListOnSearch.length
                                            : model.friendList.length,
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());

                                        String item =
                                            "${model.friendList[index].firstname!} ${model.friendList[index].lastname!}";

                                        int selectedUserId =
                                            model.friendList[index].id!;

                                        if (model.selectedUsers
                                            .contains(item)) {
                                          model.selectedUsers.remove(item);
                                        } else {
                                          if (model.selectedUsersIds.length +
                                                  1 ==
                                              model.selectedRequiredMembers) {
                                            return;
                                          }
                                          model.selectedUsers.add(item);
                                        }

                                        if (model.selectedUsersIds
                                            .contains(selectedUserId)) {
                                          model.selectedUsersIds
                                              .remove(selectedUserId);
                                        } else {
                                          if (model.selectedUsersIds.length +
                                                  1 ==
                                              model.selectedRequiredMembers) {
                                            return;
                                          }
                                          model.selectedUsersIds
                                              .add(selectedUserId);
                                        }

                                        setState(() {});
                                        print(model.selectedUsers);
                                        print(model.selectedUsersIds);
                                      },
                                      child: ListTile(
                                        trailing: Visibility(
                                            visible: _searchFriendController
                                                    .text.isEmpty
                                                ? model.selectedUsers.contains(
                                                    "${model.friendList[index].firstname} ${model.friendList[index].lastname}")
                                                : model.selectedUsers.contains(
                                                    "${model.friendListOnSearch[index].firstname} ${model.friendListOnSearch[index].lastname}"),
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Color.fromARGB(
                                                  255, 20, 79, 128),
                                            )),
                                        title: Text(_searchFriendController
                                                .text.isNotEmpty
                                            ? "${model.friendListOnSearch[index].firstname!} ${model.friendListOnSearch[index].lastname!}"
                                            : "${model.friendList[index].firstname!} ${model.friendList[index].lastname!}"),
                                        leading: model.friendList[index]
                                                    .profileImage ==
                                                null
                                            ? CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey.shade700,
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundImage: MemoryImage(
                                                    Uint8List.fromList(model
                                                        .friendList[index]
                                                        .profileImage!)),
                                              ),
                                      ),
                                    ),
                                  )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ProgressButton(
                                onNext: nextPage,
                                isAnimated: false,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ActionPageButton(
                            onTap: previousPage,
                            canQuit: true,
                            canGoBack: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Image.asset("assets/images/checked.png"),
                          ),
                          Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .create_event_view_almost_done,
                                style: kTitleStyle.copyWith(fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .create_event_view_confirm_choices,
                                style: kSubtitleStyle.copyWith(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            model.selectedCategory.name,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/city.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (model.selectedLocation != null)
                                            Text(
                                                model.locationSelectedByMap
                                                    ? (model.stickedCoordinates !=
                                                                null &&
                                                            model.sticked)
                                                        ? model
                                                            .attendedLocations
                                                            .firstWhere((element) =>
                                                                element
                                                                        .location
                                                                        .coordinates
                                                                        .latitude ==
                                                                    model
                                                                        .stickedCoordinates!
                                                                        .latitude &&
                                                                element
                                                                        .location
                                                                        .coordinates
                                                                        .longitude ==
                                                                    model
                                                                        .stickedCoordinates!
                                                                        .longitude)
                                                            .location
                                                            .city
                                                            .trim()
                                                        : model.mapCity
                                                    : model
                                                        .selectedLocation!.city
                                                        .trim(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/pin.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (model.selectedLocation != null)
                                            Text(
                                                model.locationSelectedByMap
                                                    ? (model.stickedCoordinates !=
                                                                null &&
                                                            model.sticked)
                                                        ? model
                                                            .attendedLocations
                                                            .firstWhere((element) =>
                                                                element
                                                                        .location
                                                                        .coordinates
                                                                        .latitude ==
                                                                    model
                                                                        .stickedCoordinates!
                                                                        .latitude &&
                                                                element
                                                                        .location
                                                                        .coordinates
                                                                        .longitude ==
                                                                    model
                                                                        .stickedCoordinates!
                                                                        .longitude)
                                                            .location
                                                            .locationName
                                                            .trim()
                                                        : model.mapStreet
                                                    : model.selectedLocation!
                                                        .locationName
                                                        .trim(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  model.selectedDatetime == null
                                                      ? DateTime.now()
                                                      : model.selectedDatetime!,
                                                  [
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
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/time-management.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            duration_list
                                                .firstWhere((element) =>
                                                    element.minutes ==
                                                    model.selectedDuration)
                                                .text,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          model.eventCreationProcessing
                              ? const ProgressLoadingButton()
                              : ProgressButton(
                                  onNext: () async {
                                    var response =
                                        await model.createEvent(context);

                                    switch (response) {
                                      case GOOGLE_EVENT_OVERLAPS:
                                        buildInformationSheet(
                                          message: AppLocalizations.of(context)!
                                              .event_invite_view_google_cal_problem_text,
                                          icon: const Icon(
                                            Icons.info,
                                            size: 50,
                                            color: Colors.blue,
                                          ),
                                        );
                                        break;
                                      case SERVICE_EVENT_OVERLAPS:
                                        buildInformationSheet(
                                          message: AppLocalizations.of(context)!
                                              .create_event_view_intersect_same_location,
                                          icon: const Icon(
                                            Icons.info_outline,
                                            size: 50,
                                            color: Colors.blue,
                                          ),
                                        );
                                        break;
                                      case SERVICE_BUSY_CREATOR:
                                        buildInformationSheet(
                                          message: AppLocalizations.of(context)!
                                              .event_invite_view_event_intersects_text,
                                          icon: const Icon(
                                            Icons.info_outline,
                                            size: 50,
                                            color: Colors.blue,
                                          ),
                                        );
                                        break;
                                      case SUCCESSFULLY_CREATED:
                                        nextPage();
                                        break;
                                      default:
                                        buildInformationSheet(
                                          message: AppLocalizations.of(context)!
                                              .event_invites_view_wrong_text,
                                          icon: const Icon(
                                            Icons.error,
                                            size: 50,
                                            color: Colors.red,
                                          ),
                                        );
                                    }
                                  },
                                  isAnimated: false,
                                ),
                          const SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Image.asset("assets/images/confetti.png"),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 70),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                          .create_event_view_congrats +
                                      "!",
                                  style: kTitleStyle,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .create_event_view_success,
                                  style: kSubtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          ProgressButton(
                            onNext: () => Navigator.of(context).pop(),
                            isAnimated: true,
                          ),
                          const SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                    ]),
              ),
            ));
  }

  nextPage() {
    // setState(() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.linearToEaseOut);
    // });
  }

  void chooseMapLocationPage() {
    // setState(() {
    pageController.animateToPage(4,
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

  void chooseCategoryPage() {
    // setState(() {
    pageController.jumpToPage(1);
    // });
  }

  void chooseLocationPage() {
    // setState(() {
    pageController.jumpToPage(3);
    // });
  }

  void chooseCityPage() {
    // setState(() {
    pageController.jumpToPage(2);
    // });
  }

  void chooseTimePage() {
    // setState(() {
    pageController.jumpToPage(5);
    // });
  }
}

class ActionPageButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool canQuit;
  final bool canGoBack;
  const ActionPageButton({
    Key? key,
    required this.onTap,
    required this.canQuit,
    required this.canGoBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: canGoBack && canQuit
          ? MainAxisAlignment.spaceBetween
          : canGoBack
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
      children: [
        if (canGoBack)
          GestureDetector(
            onTap: onTap,
            child: Container(
                margin: const EdgeInsets.only(top: 15, left: 15),
                child: const Icon(Icons.arrow_back_ios)),
          ),
        if (canQuit)
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin: const EdgeInsets.only(top: 15, right: 15),
                child: const Icon(Icons.close)),
          ),
      ],
    );
  }
}

class Slide extends StatelessWidget {
  final Widget hero;
  final String title;
  final String subtitle;
  final VoidCallback onNext;
  final bool isButtonAnimated;

  const Slide(
      {Key? key,
      required this.hero,
      required this.title,
      required this.subtitle,
      required this.onNext,
      required this.isButtonAnimated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: hero),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                title,
                style: kTitleStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                subtitle,
                style: kSubtitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 35,
              ),
              ProgressButton(
                onNext: onNext,
                isAnimated: isButtonAnimated,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        )
      ],
    );
  }
}
