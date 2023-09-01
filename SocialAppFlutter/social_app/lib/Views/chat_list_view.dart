// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/Models/last_message.dart';
import 'package:social_app/ViewModels/chat_list_view_model.dart';
import 'package:social_app/Views/conversation_view.dart';
import 'package:social_app/Views/create_group_view.dart';
import 'package:social_app/Views/user_profile_view.dart';
import 'package:social_app/components/shimmer_widget.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/user_settings.dart/user_settings.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ChatListViewModel(),
        disposeViewModel: false,
        onModelReady: (model) => model.initialize(context),
        builder: (context, model, child) => model.processing
            ? Scaffold(
                appBar: buildAppBar(model),
                body: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (context, index) => ListTile(
                                  leading: ShimmerWidget.circular(
                                      width: 50, height: 50),
                                  title: ShimmerWidget.rectangular(height: 16),
                                  subtitle:
                                      ShimmerWidget.rectangular(height: 14),
                                  trailing: ShimmerWidget.rectangular(
                                      height: 12,
                                      width: MediaQuery.of(context).size.width *
                                          0.1),
                                )))
                  ],
                ),
              )
            : Scaffold(
                appBar: buildAppBar(model),
                body: Column(
                  mainAxisAlignment: model.lastMessages.isNotEmpty
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: model.recommendedPersons.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.blue[50],
                            height: 100,
                            child:
                              ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: model.recommendedPersons.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder:(context, index) => GestureDetector(
                                  onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => UserProfileView(userId: model.recommendedPersons[index].id!,)),
                                      ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
                                        child: model.recommendedPersons[index].profileImage == null
                                                  ? CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor: Colors.grey.shade700,
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                      size: 30.0,
                                                    ),
                                                                            )
                                                                          : CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage: MemoryImage(Uint8List.fromList(
                                                        model.recommendedPersons[index].profileImage!)))
                                      ),
                                      SizedBox(height: 5,),
                                      Text(model.recommendedPersons[index].firstname!, style: TextStyle(fontSize: 10),)
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                      )
                    ),
                    !model.processing && model.lastMessages.isEmpty
                        ? Expanded(
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!.chat_list_view_no_conversations,
                                      style: TextStyle(fontSize: 12)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.message,
                                    color: kPrimaryColor,
                                    size: 100,
                                  )
                                ],
                              ),
                            ),
                        )
                        : Expanded(
                            child: ListView.builder(
                                physics: model.processing
                                    ? NeverScrollableScrollPhysics()
                                    : BouncingScrollPhysics(),
                                itemCount: model.processing
                                    ? 10
                                    : model.lastMessages.length,
                                itemBuilder: (context, index) => model
                                        .processing
                                    ? ListTile(
                                        leading: ShimmerWidget.circular(
                                            width: 50, height: 50),
                                        title: ShimmerWidget.rectangular(
                                            height: 16),
                                        subtitle: ShimmerWidget.rectangular(
                                            height: 14),
                                        trailing: ShimmerWidget.rectangular(
                                            height: 12,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1),
                                      )
                                    : ChatItemCard(
                                        item: model.lastMessages[index],
                                        press: () => {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConversationView(
                                                        key: conversationKey,
                                                        conversationId: model
                                                            .lastMessages[index]
                                                            .conversationId,
                                                      )))
                                        },
                                      )))
                  ],
                ),
              ));
  }

  AppBar buildAppBar(ChatListViewModel model) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: Text(AppLocalizations.of(context)!.chat_list_view_chats_text),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: model.processing
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      context: context,
                      builder: (context) =>
                          CreateGroupView(friends: model.friends),
                    );
                  },
                  icon: const Icon(
                    Icons.group_add,
                    color: Colors.white,
                    size: 30,
                  )),
        )
      ],
    );
  }
}

class ChatItemCard extends StatelessWidget {
  const ChatItemCard({Key? key, required this.item, required this.press})
      : super(key: key);

  final LastMessage item;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            item.isGroup
                ? (item.groupImage == null)
                    ? CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade700,
                        child: const Icon(
                          Icons.group,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            MemoryImage(Uint8List.fromList(item.groupImage!)))
                : item.userDetails.first.profileImage == null
                    ? CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade700,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundImage: MemoryImage(Uint8List.fromList(
                            item.userDetails.first.profileImage!))),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    !item.isGroup
                        ? "${item.userDetails.first.firstname} ${item.userDetails.first.lastname}"
                        : item.conversationDescription!,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (item.content.isNotEmpty)
                    if (item.isImage)
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          item.fromUser == ProfileService.userId
                              ? AppLocalizations.of(context)!.chat_list_view_you_sent_photo_text
                              : "${item.fromUserDetails!.firstname} ${AppLocalizations.of(context)!.chat_list_view_sent_photo_text}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10),
                        ),
                      )
                    else if (item.isVideo)
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                            item.fromUser == ProfileService.userId
                                ? AppLocalizations.of(context)!.chat_list_view_you_sent_video_text
                                : "${item.fromUserDetails!.firstname} ${AppLocalizations.of(context)!.chat_list_view_sent_video_text}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10)),
                      )
                    else
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                            item.fromUser == ProfileService.userId
                                ? "${AppLocalizations.of(context)!.chat_list_view_you_text}: ${item.content}"
                                : item.isGroup
                                    ? "${item.fromUserDetails!.firstname}: ${item.content}"
                                    : item.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10)),
                      )
                ],
              ),
            )),
            Opacity(
              opacity: 0.64,
              child: Text(
                  item.datetime.year == DateTime.now().year &&
                          item.datetime.month == DateTime.now().month &&
                          item.datetime.day == DateTime.now().day
                      ? DateFormat('HH:mm').format(item.datetime.toLocal())
                      : DateTime.now().difference(item.datetime.toLocal()).inDays <= 7
                          ? DateFormat('EEE', UserSettings.preferredLanguageCode).format(item.datetime.toLocal())
                          : DateFormat('EEE, d MMM', UserSettings.preferredLanguageCode).format(item.datetime.toLocal()),
                  style: TextStyle(fontSize: 8)),
            )
          ],
        ),
      ),
    );
  }
}
