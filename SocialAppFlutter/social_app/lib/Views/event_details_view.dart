import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Models/event_details.dart';
import 'package:social_app/ViewModels/event_details_view_model.dart';
import 'package:social_app/ViewModels/event_invites_view_model.dart';
import 'package:social_app/Views/invite_friends_to_event_view.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Models/directions.dart';
import '../Models/user.dart';
import '../components/shimmer_widget.dart';
import '../utilities/map_utils.dart';

class EventDetailsView extends StatefulWidget {
  const EventDetailsView(
      {super.key, required this.eventId, required this.sportCategoryImage});
  final int eventId;
  final String sportCategoryImage;

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  static const _initialCameraPosition = const CameraPosition(
      target: LatLng(45.77774230529796, 24.797969833016396),
      zoom: 5.788174629211426);

  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

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
    _googleMapController?.dispose();
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            )),
      );

  Future buildInviteFriendsToEventSheet(List<User> friends) =>
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          context: context,
          builder: (context) => InviteFriendsToEventView(
              friends: friends, eventId: widget.eventId));

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => EventDetailsViewModel(),
      onModelReady: (model) => model.initialize(widget.eventId),
      builder: (context, model, child) => Scaffold(
          // appBar: AppBar(
          //   leading: GestureDetector(
          //     onTap: () => Navigator.pop(context),
          //     child: Icon(Icons.arrow_back_ios)),
          //   backgroundColor: Colors.transparent,
          // ),
          body: Provider<EventDetails>.value(
        value: model.eventDetails,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ClipPath(
                clipper: ImageClipper(),
                child: Image.asset(
                  widget.sportCategoryImage,
                  fit: BoxFit.cover,
                  color: const Color(0x99000000),
                  colorBlendMode: BlendMode.darken,
                  width: screenWidth,
                  height: screenHeight * 0.35,
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ))
                        ]),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                    child: model.processing
                        ? ShimmerWidget.rectangular(
                            height: 30, width: screenWidth * 0.4)
                        : Text(
                            model.event!.location.city,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: model.processing
                              ? ShimmerWidget.rectangular(
                                  height: 20, width: screenWidth * 0.4)
                              : Text(
                                  model.event!.location.locationName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: model.processing
                        ? ShimmerWidget.rectangular(
                            height: 30, width: screenWidth * 0.4)
                        : Text(
                            "${AppLocalizations.of(context)!.event_details_view_members_text} ${model.members.length}/${model.event!.requiredMembersTotal}",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                  ),
                  model.processing
                      ? Container(
                          height: 130,
                          child: ListView.builder(
                            itemCount: 6,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ShimmerWidget.circular(width: 80, height: 80),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ShimmerWidget.rectangular(
                                      height: 20, width: 40)
                                ],
                              ),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (var member in model.members)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/UserProfileView",
                                        arguments: [member.id]);
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: ClipOval(
                                          child: member.profileImage == null
                                              ? CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor:
                                                      Colors.grey.shade700,
                                                  child: const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 40.0,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: MemoryImage(
                                                      Uint8List.fromList(member
                                                          .profileImage!))),
                                        ),
                                      ),
                                      Text(
                                        member.firstname!,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.grey[900],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppLocalizations.of(context)!
                          .event_details_view_guest_fills,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  if (model.processing)
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 15.0, bottom: 16.0, left: 15.0),
                        child: ShimmerWidget.rectangular(height: 30))
                  else
                    Visibility(
                      visible: model.event!.creator.id == ProfileService.userId,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 15.0, bottom: 16.0, left: 15.0),
                        child: model.processing
                            ? ShimmerWidget.rectangular(height: 30)
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      List<User> friendsWhichAreNotMembers =
                                          model.getFriendsWhichAreNotMembers();
                                      buildInviteFriendsToEventSheet(
                                          friendsWhichAreNotMembers);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade300),
                                    child: Text(AppLocalizations.of(context)!
                                        .event_details_view_invite_friends_text)),
                              ),
                      ),
                    ),
                  Center(
                    child: Card(
                      color: Colors.transparent,
                      elevation: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          height: screenHeight * 0.4,
                          width: screenWidth * 0.9,
                          child: model.processing
                              ? ShimmerWidget.rectangular(
                                  height: double.infinity)
                              : GoogleMap(
                                  myLocationEnabled: true,
                                  gestureRecognizers: <
                                      Factory<OneSequenceGestureRecognizer>>{
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                                  markers: {
                                    if (model.origin != null) model.origin!,
                                    if (model.destination != null)
                                      model.destination!
                                  },
                                  polylines: {
                                    if (model.info != null)
                                      Polyline(
                                          polylineId: const PolylineId(
                                              'overview_polyline'),
                                          color: Colors.black,
                                          width: 5,
                                          points: model.info!.polylinePoints
                                              .map((e) => LatLng(
                                                  e.latitude, e.longitude))
                                              .toList())
                                  },
                                  mapType: MapType.normal,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                  initialCameraPosition:
                                      model.initialCameraPosition,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    model.setGoogleMapController(controller);
                                    model.googleMapController
                                        ?.getVisibleRegion();

                                    Set<Marker> markers = {};

                                    markers = <Marker>{
                                      if (model.origin != null) model.origin!,
                                      if (model.destination != null)
                                        model.destination!
                                    };

                                    Future.delayed(
                                        const Duration(milliseconds: 200),
                                        () => model.googleMapController
                                            ?.animateCamera(
                                                CameraUpdate.newLatLngBounds(
                                                    MapUtils
                                                        .boundsFromLatLngList(
                                                            markers
                                                                .map((loc) =>
                                                                    loc.position)
                                                                .toList()),
                                                    1)));
                                  },
                                  // onLongPress: _addMarker,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50)
                ],
              ),
            ),
            if(model.event != null && model.event!.creator.id != ProfileService.userId)
            model.members.any((element) => element.id == ProfileService.userId)
                ? Visibility(
                    visible: !model.processing,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () => model.quitEvent(context),
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red)),
                          child: model.quittingEvent
                              ? const SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white)))
                              : Text(
                                  AppLocalizations.of(context)!
                                      .event_details_view_quit_text,
                                  style: TextStyle(fontSize: 12)),
                        )),
                  )
                : Visibility(
                    visible: !model.processing,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor),
                            onPressed: () async {
                              if (model.eventDetails.members.length >=
                                  model.event!.requiredMembersTotal) {
                                buildInformationSheet(
                                  message: AppLocalizations.of(context)!
                                      .event_invite_view_full_of_members_text,
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                );

                                return;
                              }

                              var response = await model.joinEvent(context,
                                  ProfileService.userId!, widget.eventId);

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
                                case SERVICE_EVENT_EXPIRED:
                                  buildInformationSheet(
                                    message: AppLocalizations.of(context)!
                                        .event_invite_view_event_not_available_text,
                                    icon: const Icon(
                                      Icons.info,
                                      size: 50,
                                      color: Colors.blue,
                                    ),
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  int count = 0;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                  break;
                                case SERVICE_EVENT_OVERLAPS:
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
                                case SERVICE_EVENT_FULL:
                                  buildInformationSheet(
                                    message: AppLocalizations.of(context)!
                                        .event_invite_view_full_of_members_text,
                                    icon: const Icon(
                                      Icons.info_outline,
                                      size: 50,
                                      color: Colors.blue,
                                    ),
                                  );
                                  break;
                                case SUCCESSFULLY_JOINED:
                                  buildInformationSheet(
                                    message: AppLocalizations.of(context)!
                                        .event_invites_view_success_text,
                                    icon: const Icon(
                                      Icons.info_outline,
                                      size: 50,
                                      color: Colors.blue,
                                    ),
                                  );
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
                            child: model.joiningEvent
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator.adaptive(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white)))
                                : Text(
                                    AppLocalizations.of(context)!
                                        .event_details_view_join_text,
                                    style: TextStyle(fontSize: 12),
                                  ))),
                  )
          ],
        ),
      )),
    );
  }
}

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset curveStartingPoint = Offset(0, 40);
    Offset curveEndPoint = Offset(size.width, size.height * 0.95);
    path.lineTo(curveStartingPoint.dx, curveStartingPoint.dy - 5);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.85,
        curveEndPoint.dx - 60, curveEndPoint.dy + 10);
    path.quadraticBezierTo(size.width * 0.99, size.height * 0.99,
        curveEndPoint.dx, curveEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
