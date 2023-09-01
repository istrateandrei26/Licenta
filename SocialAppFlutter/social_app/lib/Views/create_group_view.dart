import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/ViewModels/create_group_view_model.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Models/user.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({
    Key? key,
    required this.friends,
  }) : super(key: key);

  final List<User> friends;

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CreateGroupViewModel(),
        onModelReady: (model) {
          model.initialize(widget.friends);
        },
        builder: (context, model, child) => model.processing
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  model.setFriendListOnSearch(model.friendList
                                      .where((element) =>
                                          "${element.firstname} ${element.lastname}"
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                      .toList());
                                });
                              },
                              controller: _textEditingController,
                              maxLength: 40,
                              decoration: InputDecoration(
                                counterText: '',
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: AppLocalizations.of(context)!.conversation_details_view_search_friends_placeholder),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              model.friendListOnSearch.clear();
                              _textEditingController.clear();
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: kPrimaryColor.withOpacity(0.3),
                          ))
                    ],
                  ),
                  _textEditingController.text.isNotEmpty &&
                          model.friendListOnSearch.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: screenHeight / 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                              ),
                              Text(
                                AppLocalizations.of(context)!.conversation_details_view_no_friends_yet,
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _textEditingController.text.isNotEmpty
                              ? model.friendListOnSearch.length
                              : model.friendList.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              String item =
                                  "${model.friendList[index].firstname!} ${model.friendList[index].lastname!}";

                              int selectedUserId = model.friendList[index].id!;

                              if (model.selectedUsers.contains(item)) {
                                model.selectedUsers.remove(item);
                              } else {
                                model.selectedUsers.add(item);
                              }

                              if (model.selectedUsersIds
                                  .contains(selectedUserId)) {
                                model.selectedUsersIds.remove(selectedUserId);
                              } else {
                                model.selectedUsersIds.add(selectedUserId);
                              }

                              setState(() {});
                              print(model.selectedUsers);
                              print(model.selectedUsersIds);
                            },
                            child: ListTile(
                              trailing: Visibility(
                                  visible: _textEditingController.text.isEmpty
                                      ? model.selectedUsers.contains(
                                          "${model.friendList[index].firstname} ${model.friendList[index].lastname}")
                                      : model.selectedUsers.contains(
                                          "${model.friendListOnSearch[index].firstname} ${model.friendListOnSearch[index].lastname}"),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: kPrimaryColor,
                                  )),
                              title: Text(_textEditingController.text.isNotEmpty
                                  ? "${model.friendListOnSearch[index].firstname!} ${model.friendListOnSearch[index].lastname!}"
                                  : "${model.friendList[index].firstname!} ${model.friendList[index].lastname!}"),
                              leading:
                                  model.friendList[index].profileImage == null
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
                                                  .friendList[index]
                                                  .profileImage!)),
                                        ),
                            ),
                          ),
                        )),
                  Visibility(
                    visible: model.selectedUsers.length >=
                        2, // group has minimum 2 members
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            model.createGroupConversation();
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(kPrimaryColor)),
                          child: Text(AppLocalizations.of(context)!.create_group_view_create_text),
                        )),
                  ),
                ],
              ));
  }
}
