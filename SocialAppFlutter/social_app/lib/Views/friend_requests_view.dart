import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/ViewModels/friend_requests_view_model.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/shimmer_widget.dart';

class FriendRequestsView extends StatelessWidget {
  const FriendRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => FriendRequestsViewModel(),
        disposeViewModel: false,
        onModelReady: (model) {
          model.initialize();
        },
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              // appBar: appBar(context),
              body: Column(
                children: [
                  // Container(
                  //   margin: const EdgeInsets.only(top: 10),
                  //   child: const Text(
                  //     "Friend Requests",
                  //     style: TextStyle(
                  //         fontSize: 20, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  if (!model.processing)
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(blurRadius: 10, color: Colors.grey.shade300)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.friend_requests_view_total_friends_text,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${model.numberOfFriends}",
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  Container(
                    height: 10,
                    margin: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10),
                    color: Colors.transparent,
                  ),
                  !model.processing && model.friendsRequests.isEmpty
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.friend_requests_view_no_friend_requests_text,
                                  style: TextStyle(fontSize: 15)),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.person_add_alt_outlined,
                                color: kPrimaryColor,
                                size: 100,
                              )
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            physics: model.processing
                                ? const NeverScrollableScrollPhysics()
                                : const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: model.processing
                                ? 10
                                : model.friendsRequests.length,
                            itemBuilder: (context, index) => model.processing
                                ? Card(
                                    elevation: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                      leading: const ShimmerWidget.circular(
                                          width: 50, height: 50),
                                      title: const ShimmerWidget.rectangular(
                                          height: 16),
                                      trailing: ShimmerWidget.rectangular(
                                          height: 30,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2),
                                    ),
                                  )
                                : Card(
                                    elevation: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                        leading: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "/UserProfileView",
                                                arguments: [
                                                  model.friendsRequests[index]
                                                      .user.id
                                                ]);
                                          },
                                          child: model.friendsRequests[index]
                                                      .user.profileImage ==
                                                  null
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey.shade700,
                                                  child: const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 30.0,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: MemoryImage(
                                                      Uint8List.fromList(model
                                                          .friendsRequests[
                                                              index]
                                                          .user
                                                          .profileImage!))),
                                        ),
                                        title: Text(
                                          "${model.friendsRequests[index].user.firstname} ${model.friendsRequests[index].user.lastname}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                        trailing: ElevatedButton(
                                          onPressed: () => model
                                                  .friendsRequests[index]
                                                  .accepted
                                              ? null
                                              : model.acceptFriendRequest(
                                                  model.friendsRequests[index]
                                                      .friendRequestId,
                                                  model.friendsRequests[index]
                                                      .user.id!,
                                                  ProfileService.userId!),
                                          style: model.friendsRequests[index]
                                                  .accepted
                                              ? ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.grey))
                                              : ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          kPrimaryColor)),
                                          child: model.friendsRequests[index]
                                                  .accepted
                                              ? Text(
                                                  AppLocalizations.of(context)!.friend_requests_view_accepted_text,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                              : Text(
                                                  AppLocalizations.of(context)!.friend_requests_view_accept_text,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                        )),
                                  ),
                          ),
                        )
                ],
              ),
            ));
  }
}

PreferredSizeWidget appBar(BuildContext context) {
  return AppBar(
    title: const Icon(
      Icons.notifications,
      size: 25,
      color: Colors.grey,
    ),
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.grey,
    ),
  );
}
