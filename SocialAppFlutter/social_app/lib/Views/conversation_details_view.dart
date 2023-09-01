import 'dart:async';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_app/ViewModels/conversation_details_view_model.dart';
import 'package:social_app/Views/add_members_to_chat_group_view.dart';
import 'package:social_app/Views/settings_view.dart';
import 'package:social_app/components/group_image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Models/user.dart';
import '../components/edit_group_name_widget.dart';
import '../components/leaving_group_confirmation_widget.dart';

final GlobalKey<_ConversationDetailsViewState> conversationDetailsKey =
    GlobalKey(debugLabel: "ConversationDetails Key");

class ConversationDetailsView extends StatefulWidget {
  final bool isGroup;
  List<User> members;
  String conversationDetailName;
  List<int>? conversationDetailImage;
  List<User> friends;
  int conversationId;

  ConversationDetailsView(
      {super.key,
      required this.isGroup,
      required this.members,
      required this.conversationDetailName,
      required this.conversationDetailImage,
      required this.conversationId,
      required this.friends});

  @override
  State<ConversationDetailsView> createState() =>
      _ConversationDetailsViewState();
}

class _ConversationDetailsViewState extends State<ConversationDetailsView> {
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
  Future buildEditGroupNameSheet(ConversationDetailsViewModel model) =>
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
              child: EditGroupNameWidget(
                  text: AppLocalizations.of(context)!.conversation_details_view_enter_new_group_name,
                  handler: (newGroupName) async {
                    await model.updateGroupName(newGroupName);
                  }),
            ),
          ),
        ),
      );

  Future buildGalleryImagePickerSheet(ConversationDetailsViewModel model) =>
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
              child: GroupImagePicker(
                  confirmText: AppLocalizations.of(context)!.conversation_details_view_confirm_text,
                  choosePictureText: AppLocalizations.of(context)!.conversation_details_view_choose_new_group_picture,
                  handler: (imageFile) async {
                    await model.updateGroupImage(imageFile);
                  })));

  Future buildGroupLeavingConfirmationSheet(
          ConversationDetailsViewModel model) =>
      showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (context) => LeavingGroupConfirmationWidget(
            areYouSureText: AppLocalizations.of(context)!.conversation_details_view_sure,
            yesText: AppLocalizations.of(context)!.conversation_details_view_yes_sure,
            noText: AppLocalizations.of(context)!.conversation_details_view_no_sure,
            handler: () => model.leaveGroup(context)),
      );

  Future buildAddMembersSheet(List<User> friends, int groupId) =>
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          context: context,
          builder: (context) => AddMembersToChatGroupView(
                friends: friends,
                groupId: groupId,
              ));

  int get conversationId => widget.conversationId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ConversationDetailsViewModel(),
        disposeViewModel: false,
        onModelReady: (model) => model.initialize(
            widget.isGroup,
            widget.members,
            widget.conversationDetailName,
            widget.conversationDetailImage,
            widget.conversationId,
            widget.friends,
            context),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const BackButton(),
                        Expanded(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                model.isGroup
                                    ? AppLocalizations.of(context)!.conversation_details_view_group_details_text
                                    : AppLocalizations.of(context)!.conversation_details_view_user_details_text,
                                style: const TextStyle(fontSize: 18),
                              )),
                        ),
                        const SizedBox(width: 50)
                      ],
                    )),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: model.isGroup
                            ? model.conversationDetailImage == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey.shade700,
                                    radius: 50,
                                    child: const Icon(
                                      Icons.group,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: MemoryImage(
                                        Uint8List.fromList(
                                            model.conversationDetailImage!)),
                                    radius: 50,
                                  )
                            : model.members.first.profileImage == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey.shade700,
                                    radius: 50,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: MemoryImage(
                                      Uint8List.fromList(
                                          model.members.first.profileImage!),
                                    ),
                                    radius: 50,
                                  ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          model.conversationDetailName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Text(model.isGroup ? AppLocalizations.of(context)!.conversation_details_view_members_text : AppLocalizations.of(context)!.conversation_details_view_common_interests_text,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600)),
                          const Spacer()
                        ],
                      ),
                      const SizedBox(height: 10),
                      model.isGroup
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) => index == 0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                            )),
                                        child: ListTile(
                                          leading: model.members[index]
                                                      .profileImage ==
                                                  null
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey.shade700,
                                                  child: const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: MemoryImage(
                                                      Uint8List.fromList(model
                                                          .members[index]
                                                          .profileImage!))),
                                          title: Text(
                                            "${model.members[index].firstname!} ${model.members[index].lastname!}",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    )
                                  : index == model.members.length - 1
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20.0),
                                                  bottomRight:
                                                      Radius.circular(20.0),
                                                )),
                                            child: ListTile(
                                              leading: model.members[index]
                                                          .profileImage ==
                                                      null
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey.shade700,
                                                      child: const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          MemoryImage(Uint8List
                                                              .fromList(model
                                                                  .members[
                                                                      index]
                                                                  .profileImage!))),
                                              title: Text(
                                                  "${model.members[index].firstname!} ${model.members[index].lastname!}",
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: ListTile(
                                            tileColor: Colors.grey.shade200,
                                            leading: model.members[index]
                                                        .profileImage ==
                                                    null
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey.shade700,
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage: MemoryImage(
                                                        Uint8List.fromList(model
                                                            .members[index]
                                                            .profileImage!))),
                                            title: Text(
                                                "${model.members[index].firstname!} ${model.members[index].lastname!}",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                        ),
                              itemCount: model.members.length)
                          :
                          // here handle when list is empty
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue.shade200,
                                      radius: 25,
                                      child: Image.asset(
                                        "${model.commonAttendedCategories?[index].sportCategory.image.replaceFirst('/event_card_images', '').replaceFirst("images", "icons").split(".")[0]}.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                  itemCount:
                                      model.commonAttendedCategories?.length,
                                ),
                              ),
                            ),
                      Visibility(
                        visible: !model.isGroup,
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(AppLocalizations.of(context)!.conversation_details_view_common_groups_text,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                Spacer()
                              ],
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                                itemCount: model.commonGroups?.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: model
                                                        .commonGroups?.length ==
                                                    1
                                                ? const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20.0),
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    bottomLeft:
                                                        Radius.circular(20.0),
                                                    bottomRight:
                                                        Radius.circular(20.0),
                                                  )
                                                : index == 0
                                                    ? const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                20.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                20.0),
                                                      )
                                                    : index ==
                                                            model.commonGroups!
                                                                    .length -
                                                                1
                                                        ? const BorderRadius
                                                            .only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20.0),
                                                          )
                                                        : const BorderRadius
                                                            .all(Radius.zero)),
                                        child: ListTile(
                                          title: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(
                                                  model.commonGroups![index]
                                                      .groupName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 14))),
                                          leading: model.commonGroups![index]
                                                      .groupImage ==
                                                  null
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey.shade700,
                                                  radius: 20,
                                                  child: const Icon(
                                                    Icons.group,
                                                    color: Colors.white,
                                                    size: 25.0,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: MemoryImage(
                                                      Uint8List.fromList(model
                                                          .commonGroups![index]
                                                          .groupImage!)),
                                                ),
                                        ),
                                      ),
                                    ))
                          ],
                        ),
                      ),
                      Visibility(
                        visible: model.isGroup,
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(AppLocalizations.of(context)!.conversation_details_view_settings_text,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                Spacer()
                              ],
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        border: Border.all(
                                            color: Colors.transparent),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15))),
                                    child: SettingsOptionWidget(
                                      icon: const CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Icon(Icons.edit,
                                            color: Colors.white),
                                      ),
                                      title: AppLocalizations.of(context)!.conversation_details_view_change_group_name_text,
                                      onPressed: () =>
                                          buildEditGroupNameSheet(model),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border:
                                          Border.all(color: Colors.transparent),
                                    ),
                                    child: SettingsOptionWidget(
                                      icon: CircleAvatar(
                                        backgroundColor: Colors.pink.shade900,
                                        child: const Icon(
                                            Icons
                                                .photo_size_select_actual_rounded,
                                            color: Colors.white),
                                      ),
                                      title: AppLocalizations.of(context)!.conversation_details_view_change_group_image_text,
                                      onPressed: () =>
                                          buildGalleryImagePickerSheet(model),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border:
                                          Border.all(color: Colors.transparent),
                                    ),
                                    child: SettingsOptionWidget(
                                      icon: const CircleAvatar(
                                        backgroundColor: Colors.blueGrey,
                                        child: Icon(Icons.person_add,
                                            color: Colors.white),
                                      ),
                                      title: AppLocalizations.of(context)!.conversation_details_view_add_members_text,
                                      onPressed: () {
                                        List<User> friendsWhichAreNotInGroup =
                                            model
                                                .getFriendsWhichAreNotInGroup();
                                        buildAddMembersSheet(
                                            friendsWhichAreNotInGroup,
                                            model.conversationId);
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        border: Border.all(
                                            color: Colors.transparent),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15))),
                                    child: SettingsOptionWidget(
                                      icon: const CircleAvatar(
                                        backgroundColor: Colors.black,
                                        child: Icon(Icons.exit_to_app,
                                            color: Colors.white),
                                      ),
                                      title: AppLocalizations.of(context)!.conversation_details_view_leave_group_text,
                                      onPressed: () =>
                                          buildGroupLeavingConfirmationSheet(
                                              model),
                                    ),
                                  ),
                                  const SizedBox(height: 50)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
