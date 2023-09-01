import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Models/event_review_info.dart';
import 'package:social_app/Views/events_view.dart';
import 'package:social_app/Views/review_view.dart';
import 'package:social_app/components/search_location_widget.dart';
import 'package:social_app/services/google/google_sign_in_service.dart';
import 'package:social_app/services/iauth_service.dart';
import 'package:social_app/utilities/service_locator/locator.dart';
import '../models/post.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ApiTestView extends StatefulWidget {
  const ApiTestView({super.key});

  @override
  State<ApiTestView> createState() => _ApiTestViewState();
}

class _ApiTestViewState extends State<ApiTestView> {
  List<Post>? posts;
  String name = '';
  File? file;
  ImagePicker image = ImagePicker();
  List<int>? bytes;

  LatLng coords = const LatLng(44.47990714433067, 26.123755353945267);

  TextEditingController changeGroupNameController = TextEditingController();

  gedData() async {
    // var result = await provider.get<IEventsService>().getEvents();
  }

  getCoordinatesInfo() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(45.783680987729475, 27.679685029974838);

    print(placemarks.reversed.last.country);
    print(placemarks.reversed.last.locality);
  }

  Future showInternetMissingSheet(
          {required Icon icon}) =>
      showModalBottomSheet(
        isDismissible: false,
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
                        AppLocalizations.of(context)!.internet_sheet_no_connectivity_message,
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
                  onPressed: () {}, 
                  style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Adjust the value to change the button's corner radius
                  ),
                ),
                  child: Text(AppLocalizations.of(context)!.internet_sheet_no_connectivity_dismiss_message, style: TextStyle(fontSize: 12),)
                )
              ],
            )),
      );

  Future buildSearchByLocationSheet() => showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (context) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: SearchLocationWidget(
                  availableCities: const [],
                  handler: (searchLocationConfirmed) => () {}),
            ),
          ),
        ),
      );

  Future buildReviewSheet(EventReviewInfo eventReviewInfo) =>
      showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ReviewView(eventReviewInfo: eventReviewInfo),
      );

  Future buildEditGroupNameSheet({required Icon icon}) => showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (context) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  height: 140,
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
                            child: TextField(
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2.0,
                                          color: Colors.blue.shade200)),
                                  hintText: 'Enter new group name'),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // var screenHeight = MediaQuery.of(context).size.height;
    // var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body:
          // ListTile(
          //   onTap: () {
          //     // Navigator.push(context, MaterialPageRoute(builder:(context) => const CardFormView(1,"")));
          //   },
          //   title: const Text("Go to the Card Form"),
          //   trailing: const Icon(Icons.chevron_right_outlined),
          // )
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            bytes != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(Uint8List.fromList(bytes!)),
                  )
                : const SizedBox.shrink(),
            Container(
              height: 100,
              width: 100,
              color: Colors.red,
              child: file == null
                  ? const Icon(
                      Icons.image,
                      size: 50,
                    )
                  : Image.file(
                      file!,
                      fit: BoxFit.fill,
                    ),
            ),
            MaterialButton(
              onPressed: () {
                getgall();
              },
              color: Colors.blue[900],
              child: const Text(
                "take from gallery",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EventsView()));
                },
                child: const Text("EVENTS VIEW")),
            ElevatedButton(
              child: const Text("Logout"),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInService>(context, listen: false);
                provider.googleLogout();
              },
            ),
            MaterialButton(
              onPressed: () {
                getcam();
              },
              color: Colors.blue[900],
              child: const Text(
                "take from camera",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              // ElevatedButton.icon(
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.white,
              //       foregroundColor: Colors.black,
              //       minimumSize: const Size(double.infinity, 50)),
              //   label: const Text("Sign Up with Google"),
              //   icon: const FaIcon(
              //     FontAwesomeIcons.google,
              //     color: Colors.red,
              //   ),
              //   onPressed: () {
              //     final provider =
              //         Provider.of<GoogleSignInService>(context, listen: false);
              //     provider.googleLogin();
              //   },
              // ),

              // ElevatedButton(
              //   onPressed: () {
              //     NotificationService()
              //         .showNotification(title: "Sample title", body: "It works!");
              //   },
              //   child: const Text("Show Notification"),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     NotificationService().scheduleNotification(
              //         title: "Scheduled Notification",
              //         body: "It works!",
              //         scheduledNotificationDateTime:
              //             DateTime.now().add(const Duration(seconds: 5)));
              //   },
              //   child: const Text("Schedule Notification"),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     LocalCalendarService().addEventToLocalCalendar("", "",DateTime.now(), 90.0);
              //   },
              //   child: const Text("Add Event to Local Calendar"),
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     var response = await provider
              //         .get<IEventsService>()
              //         .getEventsWithoutReview(34);

              //     buildReviewSheet(response!.eventReviewInfos.firstWhere((element) => element.event.id == 3021));
              //   },
              //   child: const Text("SHOW BOTTOM MODAL SHEET"),
              // ),
            ),
            MaterialButton(
              onPressed: () =>
                  buildEditGroupNameSheet(icon: const Icon(Icons.edit)),
              color: Colors.blue[900],
              child: const Text(
                "Open Group Name Change Modal Bottom Sheet",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () => getCoordinatesInfo(),
              color: Colors.blue[900],
              child: const Text(
                "Get Coordinates Info",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () => buildSearchByLocationSheet(),
              color: Colors.blue[900],
              child: const Text(
                "Search City",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () => showInternetMissingSheet(
                  icon: Icon(
                    Icons.signal_cellular_connected_no_internet_0_bar_sharp,
                    color: Colors.red,
                  )),
              color: Colors.blue[900],
              child: const Text(
                "Show internet sheet",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getcam() async {
    // ignore: deprecated_member_use
    var img = await image.getImage(source: ImageSource.camera);
    setState(() {
      file = File(img!.path);
    });
  }

  getgall() async {
    // ignore: deprecated_member_use
    var img = await image.getImage(source: ImageSource.gallery);

    var imageContentWrapper = await provider
        .get<IAuthService>()
        .saveProfileImage(File(img!.path), 1043);

    setState(() {
      bytes = Uint8List.fromList(imageContentWrapper!.profileImage);
    });
  }

  Future<String?> openDialogSetName() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title:
                const Text("Change Group Name", style: TextStyle(fontSize: 14)),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: 'New group name',
                  hintStyle: TextStyle(fontSize: 12)),
              controller: changeGroupNameController,
            ),
            actions: [
              TextButton(
                  onPressed: submit,
                  child: const Text("OK", style: TextStyle(fontSize: 10)))
            ],
          ));

  void submit() {
    Navigator.of(context).pop(changeGroupNameController.text);
    changeGroupNameController.clear();
  }
}
