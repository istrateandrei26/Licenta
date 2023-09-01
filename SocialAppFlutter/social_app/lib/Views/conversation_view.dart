import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/Models/message.dart';
import 'package:social_app/ViewModels/conversation_view_model.dart';
import 'package:social_app/Views/conversation_details_view.dart';
import 'package:social_app/components/network_image_widget.dart';
import 'package:social_app/components/network_player_widget.dart';
import 'package:social_app/components/reactions_list_widget.dart';
import 'package:social_app/services/icloudstorage_service.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:social_app/utilities/service_locator/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Models/user.dart';
import '../components/media_grid.dart';

final GlobalKey<_ConversationViewState> conversationKey =
    GlobalKey(debugLabel: "Conversation Key");

class ConversationView extends StatefulWidget {
  final int conversationId;

  ConversationView({
    super.key,
    required this.conversationId,
  });

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {


  int get conversationId => widget.conversationId;

  // Widget buildSheet() => const MediaGrid(userId: model.,);
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
        context: this.context,
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
        context: this.context,
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

  Future uploadPhoto(File? file) async {
    if (file == null) return;

    final filename = basename(file.path);
    final destination = "/files/$filename";

    final downloadUrl = await provider
        .get<ICloudStorageService>()
        .uploadFile(destination, file);

    print('Download link: $downloadUrl');
  }

  Future buildReactionsListSheet(
          List<User> usersWhoReacted, BuildContext context) =>
      showModalBottomSheet(
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
                child: ReactionsListWidget(usersWhoReacted: usersWhoReacted)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ConversationViewModel(),
        onModelReady: (model) {
          model.initialize(widget.conversationId);
        },
        builder: (context, model, child) => model.processing
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      const BackButton(),
                      model.isGroup
                          ? (model.groupImage == null)
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey.shade700,
                                  child: const Icon(
                                    Icons.group,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: MemoryImage(
                                      Uint8List.fromList(model.groupImage!)))
                          : model.conversationPartners.first.profileImage ==
                                  null
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey.shade700,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: MemoryImage(
                                      Uint8List.fromList(model
                                          .conversationPartners
                                          .first
                                          .profileImage!))),
                      const SizedBox(
                        width: kDefaultPadding * 0.75,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ConversationDetailsView(
                                          key: conversationDetailsKey,
                                          isGroup: model.isGroup,
                                          members: model.conversationPartners,
                                          conversationDetailName: model.isGroup
                                              ? model.groupName!
                                              : "${model.conversationPartners.first.firstname!} ${model.conversationPartners.first.lastname!}",
                                          conversationDetailImage: model.isGroup
                                              ? model.groupImage
                                              : model.conversationPartners.first
                                                  .profileImage!,
                                          conversationId: model.conversationId,
                                          friends: model.friends,
                                        )));
                          },
                          child: Text(
                            !model.isGroup
                                ? "${model.conversationPartners.first.firstname} ${model.conversationPartners.first.lastname}"
                                : model.groupName!,
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    // Column(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 20.0),
                    //       child: Center(
                    //         child:
                    //         model.isGroup ?
                    //         (model.groupImage == null) ?
                    //         CircleAvatar(
                    //           radius: screenWidth * 0.19,
                    //           backgroundColor: Colors.grey.shade700,
                    //           child: const Icon(
                    //             Icons.group,
                    //             color: Colors.white,
                    //             size: 30.0,
                    //           ),
                    //         )
                    //         :
                    //         CircleAvatar(
                    //           radius: screenWidth * 0.19,
                    //           backgroundImage: MemoryImage(Uint8List.fromList(model.groupImage!))
                    //         )
                    //         : model.conversationPartners.first!.profileImage ==
                    //               null
                    //           ? CircleAvatar(
                    //             radius: screenWidth * 0.19,
                    //               backgroundColor: Colors.grey.shade700,
                    //               child: const Icon(
                    //                 Icons.person,
                    //                 color: Colors.white,
                    //                 size: 30.0,
                    //               ),
                    //             )
                    //           : CircleAvatar(
                    //             radius: screenWidth * 0.14,
                    //               backgroundImage: MemoryImage(
                    //                   Uint8List.fromList(model
                    //                       .conversationPartners
                    //                       .first!
                    //                       .profileImage!))),
                    //       ),
                    //     ),
                    //     const Text("You are friends on SportNet", style: TextStyle(color: Colors.black),)
                    //   ],
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: model.messages.length,
                          itemBuilder: (context, index) => Visibility(
                            visible: model.messages[index].content.isEmpty
                                ? false
                                : true,
                            child: MessageCard(
                                index: index,
                                isGroup: model.isGroup,
                                onReactionsContainerDoubleTap: (model.messageIsFromMyself(model.messages[index]) ||
                                        (!model.iAlreadyReactedOnMessage(
                                            model.messages[index])))
                                    ? () {}
                                    : () => model.removeReactionFromMessage(
                                        model.messages[index].id!),
                                onLongPress: !model.messageHasReactions(model.messages[index])
                                    ? () {}
                                    : () => buildReactionsListSheet(
                                        model.messages[index].usersWhoReacted,
                                        context),
                                onDoubleTap: (model.messageIsFromMyself(model.messages[index]) ||
                                        model.iAlreadyReactedOnMessage(model.messages[index]))
                                    ? () {}
                                    : () => model.reactToMessage(model.messages[index].id!),
                                message: model.messages[index],
                                beforeMessage: index != 0 ? model.messages[index - 1] : model.messages[0],
                                mainAxisAlignment: model.userId == model.messages[index].fromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                                decorationColor: kPrimaryColor.withOpacity(model.userId == model.messages[index].fromUser ? 1 : 0.1),
                                textColor: model.userId == model.messages[index].fromUser ? Colors.white : Theme.of(context).textTheme.bodyText1?.color),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2),
                      decoration: const BoxDecoration(
                          // color: Theme.of(context).scaffoldBackgroundColor,   // ################################################
                          ),
                      child: SafeArea(
                          child: Flex(direction: Axis.horizontal, children: <
                              Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 0.75),
                            decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // await selectPhoto();
                                    showModalBottomSheet(
                                        isScrollControlled: true,
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
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20))),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 20),
                                                child: MediaGrid(
                                                  userId: model.userId,
                                                  conversationId:
                                                      model.conversationId,
                                                  functionName:
                                                      "SendFileMessage",
                                                  handler: (downloadUrl,
                                                          isImage, isVideo) =>
                                                      model.sendFileMessage(
                                                          downloadUrl,
                                                          isImage,
                                                          isVideo),
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Icon(
                                    Icons.photo_outlined,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color
                                        ?.withOpacity(0.64),
                                  ),
                                ),
                                const SizedBox(
                                  width: kDefaultPadding / 4,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: model.messageTextController,
                                    maxLength: 80,
                                    decoration: InputDecoration(
                                      counterText: '',
                                        hintText: AppLocalizations.of(context)!.conversation_view_type_message_placeholder_text,
                                        border: InputBorder.none),
                                  ),
                                ),
                                // Icon(
                                //   Icons.attach_file,
                                //   color: Theme.of(context)
                                //       .textTheme
                                //       .bodyText1
                                //       ?.color
                                //       ?.withOpacity(0.64),
                                // ),
                                // Icon(
                                //   Icons.camera_alt_outlined,
                                //   color: Theme.of(context)
                                //       .textTheme
                                //       .bodyText1
                                //       ?.color
                                //       ?.withOpacity(0.64),
                                // ),
                                GestureDetector(
                                  onTap: () => model.sendTextMessage(),
                                  child: Icon(
                                    Icons.send_rounded,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color
                                        ?.withOpacity(0.64),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])),
                    )
                  ],
                ),
              ));
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard(
      {Key? key,
      required this.message,
      required this.mainAxisAlignment,
      required this.decorationColor,
      required this.textColor,
      required this.onDoubleTap,
      required this.onLongPress,
      required this.onReactionsContainerDoubleTap,
      required this.beforeMessage,
      required this.isGroup,
      required this.index})
      : super(key: key);

  final int index;
  final bool isGroup;
  final Message beforeMessage;
  final Message message;
  final MainAxisAlignment mainAxisAlignment;
  final Color decorationColor;
  final Color? textColor;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;
  final VoidCallback onReactionsContainerDoubleTap;

  @override
  Widget build(BuildContext context) {
    if (message.isImage) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: [
            if (message.datetime.difference(beforeMessage.datetime).inDays != 0)
              Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Text(
                    DateTime.now().difference(message.datetime).inDays == 0
                        ? AppLocalizations.of(context)!.conversation_view_today_text
                        : DateTime.now().difference(message.datetime).inDays ==
                                1
                            ? AppLocalizations.of(context)!.conversation_view_yesterday_text
                            : DateTime.now()
                                        .difference(message.datetime)
                                        .inDays <
                                    7
                                ? DateFormat('EEE').format(message.datetime)
                                : DateFormat('EEE, d MMM')
                                    .format(message.datetime),
                    style: TextStyle(fontSize: 10),
                  )),
            Row(
              mainAxisAlignment: mainAxisAlignment,
              children: [
                Column(
                  crossAxisAlignment: message.fromUser == ProfileService.userId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (beforeMessage.fromUser != message.fromUser ||
                        index == 0 || index == 1)
                      Container(
                        margin: EdgeInsets.only(
                            top: beforeMessage.fromUser == message.fromUser
                                ? 5
                                : 30),
                        child: Row(
                          children: [
                            message.fromUserDetails!.profileImage == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey.shade700,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 10.0,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 10,
                                    backgroundImage: MemoryImage(
                                        Uint8List.fromList(message
                                            .fromUserDetails!.profileImage!))),
                            SizedBox(
                              width: 5,
                            ),
                            if (isGroup)
                              Text(
                                message.fromUserDetails!.firstname!,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onLongPress: onLongPress,
                      onDoubleTap: onDoubleTap,
                      child: Stack(children: [
                        Container(
                          // padding: const EdgeInsets.symmetric(
                          //     // horizontal: kDefaultPadding * 0.75,
                          //     vertical: kDefaultPadding * 0.4),
                          margin: EdgeInsets.only(
                              top: 10,
                              bottom: 12,
                              left: message.fromUser == ProfileService.userId!
                                  ? 10
                                  : 0),
                          decoration: BoxDecoration(
                              color: decorationColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft:
                                      message.fromUser != ProfileService.userId
                                          ? Radius.zero
                                          : const Radius.circular(10),
                                  bottomRight:
                                      message.fromUser == ProfileService.userId
                                          ? Radius.zero
                                          : const Radius.circular(10))),
                          child: NetworkImageWidget(imageUrl: message.content),
                        ),
                        Positioned(
                            bottom: 0,
                            left: ProfileService.userId! != message.fromUser
                                ? 5
                                : null,
                            right: ProfileService.userId! != message.fromUser
                                ? null
                                : 5,
                            child: message.usersWhoReacted.isEmpty
                                ? const SizedBox.shrink()
                                : GestureDetector(
                                    onDoubleTap: onReactionsContainerDoubleTap,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          border: Border.all(
                                            width: 3,
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                          )),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: 10,
                                              height: 10,
                                              child: Image.asset(
                                                  "assets/icons/medal.png")),
                                          if (message.usersWhoReacted.length >
                                              1)
                                            Text(
                                              "${message.usersWhoReacted.length}",
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            )
                                        ],
                                      ),
                                    ),
                                  ))
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else if (message.isVideo) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: [
            if (message.datetime.difference(beforeMessage.datetime).inDays != 0)
              Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Text(
                    DateTime.now().difference(message.datetime).inDays == 0
                        ? AppLocalizations.of(context)!.conversation_view_today_text
                        : DateTime.now().difference(message.datetime).inDays ==
                                1
                            ? AppLocalizations.of(context)!.conversation_view_yesterday_text
                            : DateTime.now()
                                        .difference(message.datetime)
                                        .inDays <
                                    7
                                ? DateFormat('EEE').format(message.datetime)
                                : DateFormat('EEE, d MMM')
                                    .format(message.datetime),
                    style: TextStyle(fontSize: 10),
                  )),
            Row(
              mainAxisAlignment: mainAxisAlignment,
              children: [
                Column(
                  crossAxisAlignment: message.fromUser == ProfileService.userId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (beforeMessage.fromUser != message.fromUser ||
                        index == 0 || index == 1)
                      Container(
                        margin: EdgeInsets.only(
                            top: beforeMessage.fromUser == message.fromUser
                                ? 5
                                : 30),
                        child: Row(
                          children: [
                            message.fromUserDetails!.profileImage == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey.shade700,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 10.0,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 10,
                                    backgroundImage: MemoryImage(
                                        Uint8List.fromList(message
                                            .fromUserDetails!.profileImage!))),
                            SizedBox(
                              width: 5,
                            ),
                            if (isGroup)
                              Text(
                                message.fromUserDetails!.firstname!,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onLongPress: onLongPress,
                      onDoubleTap: onDoubleTap,
                      child: Stack(children: [
                        Container(
                          // padding: const EdgeInsets.symmetric(
                          //   horizontal: kDefaultPadding * 0.75,
                          //   vertical: kDefaultPadding / 2),
                          margin: EdgeInsets.only(
                              top: 10,
                              bottom: 12,
                              left: message.fromUser == ProfileService.userId!
                                  ? 10
                                  : 0),
                          decoration: BoxDecoration(
                              color: decorationColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft:
                                      message.fromUser != ProfileService.userId
                                          ? Radius.zero
                                          : const Radius.circular(10),
                                  bottomRight:
                                      message.fromUser == ProfileService.userId
                                          ? Radius.zero
                                          : const Radius.circular(10))),

                          child: NetworkPlayerWidget(
                              alignment: mainAxisAlignment,
                              videoUrl: message.content),
                        ),
                        Positioned(
                            bottom: 0,
                            left: ProfileService.userId! != message.fromUser
                                ? 5
                                : null,
                            right: ProfileService.userId! != message.fromUser
                                ? null
                                : 5,
                            child: message.usersWhoReacted.isEmpty
                                ? const SizedBox.shrink()
                                : GestureDetector(
                                    onDoubleTap: onReactionsContainerDoubleTap,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          border: Border.all(
                                            width: 3,
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                          )),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: 10,
                                              height: 10,
                                              child: Image.asset(
                                                  "assets/icons/medal.png")),
                                          if (message.usersWhoReacted.length >
                                              1)
                                            Text(
                                              "${message.usersWhoReacted.length}",
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            )
                                        ],
                                      ),
                                    ),
                                  ))
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: [
            if (message.datetime.difference(beforeMessage.datetime).inDays != 0)
              Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Text(
                    DateTime.now().difference(message.datetime).inDays == 0
                        ? AppLocalizations.of(context)!.conversation_view_today_text
                        : DateTime.now().difference(message.datetime).inDays ==
                                1
                            ? AppLocalizations.of(context)!.conversation_view_yesterday_text
                            : DateTime.now()
                                        .difference(message.datetime)
                                        .inDays <
                                    7
                                ? DateFormat('EEE').format(message.datetime)
                                : DateFormat('EEE, d MMM')
                                    .format(message.datetime),
                    style: TextStyle(fontSize: 10),
                  )),
            Row(
              mainAxisAlignment: mainAxisAlignment,
              children: [
                Column(
                  crossAxisAlignment: message.fromUser == ProfileService.userId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (beforeMessage.fromUser != message.fromUser ||
                        index == 0 || index == 1)
                      Container(
                        margin: EdgeInsets.only(
                            top: beforeMessage.fromUser == message.fromUser
                                ? 5
                                : 30),
                        child: Row(
                          children: [
                            message.fromUserDetails!.profileImage == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey.shade700,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 10.0,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 10,
                                    backgroundImage: MemoryImage(
                                        Uint8List.fromList(message
                                            .fromUserDetails!.profileImage!))),
                            SizedBox(
                              width: 5,
                            ),
                            if (isGroup)
                              Text(
                                message.fromUserDetails!.firstname!,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onLongPress: onLongPress,
                      onDoubleTap: onDoubleTap,
                      child: Stack(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 0.75,
                              vertical: kDefaultPadding / 2),
                          margin: EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: message.fromUser == ProfileService.userId!
                                  ? 10
                                  : 0),
                          decoration: BoxDecoration(
                              color: decorationColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(15),
                                  topRight: const Radius.circular(15),
                                  bottomLeft:
                                      message.fromUser != ProfileService.userId
                                          ? Radius.zero
                                          : const Radius.circular(15),
                                  bottomRight:
                                      message.fromUser == ProfileService.userId
                                          ? Radius.zero
                                          : const Radius.circular(15))),
                          child: Container(
                            constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                             
                            ),
                            child: Text(message.content,
                            // maxLines: 2,
                            // overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: textColor, fontSize: 12)),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: ProfileService.userId! != message.fromUser
                                ? 5
                                : null,
                            right: ProfileService.userId! != message.fromUser
                                ? null
                                : 5,
                            child: message.usersWhoReacted.isEmpty
                                ? const SizedBox.shrink()
                                : GestureDetector(
                                    onDoubleTap: onReactionsContainerDoubleTap,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          border: Border.all(
                                            width: 3,
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                          )),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: 10,
                                              height: 10,
                                              child: Image.asset(
                                                  "assets/icons/medal.png")),
                                          if (message.usersWhoReacted.length >
                                              1)
                                            Text(
                                              "${message.usersWhoReacted.length}",
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            )
                                        ],
                                      ),
                                    ),
                                  ))
                      ]),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      );
    }
  }
}
