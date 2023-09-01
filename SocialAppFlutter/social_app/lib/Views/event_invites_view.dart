import 'package:flutter/material.dart';
import 'package:social_app/ViewModels/event_invites_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/event_invitation_card.dart';
import '../components/shimmer_event_invite_item_widget.dart';
import '../utilities/constants.dart';

class EventInvitesView extends StatefulWidget {
  const EventInvitesView({super.key});

  @override
  State<EventInvitesView> createState() => _EventInvitesViewState();
}

class _EventInvitesViewState extends State<EventInvitesView> {
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

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => EventInvitesViewModel(),
        disposeViewModel: false,
        onModelReady: (model) => model.initialize(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  !model.processing && model.eventInvites.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.event_invites_view_no_event_invites_text,
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.insert_invitation_outlined,
                                  color: kPrimaryColor,
                                  size: 100,
                                )
                              ],
                            ),
                          ),
                        )
                      :
                      // Center(child: ElevatedButton(onPressed: () => model.addGoogleCalendarEvent(context, null), child: const Text("Add Google Calendar Event"))),
                      Expanded(
                          child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              physics: model.processing
                                  ? const NeverScrollableScrollPhysics()
                                  : const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: model.processing
                                  ? 10
                                  : model.eventInvites.length,
                              itemBuilder: (context, index) => model.processing
                                  ? ShimmerEventInviteItemWidget(
                                      screenHeight: screenHeight,
                                      screenWidth: screenWidth)
                                  : EventInvitationCard(
                                      screenHeight: screenHeight,
                                      screenWidth: screenWidth,
                                      city: model.eventInvites[index].event
                                          .location.city,
                                      locationName: model.eventInvites[index]
                                          .event.location.locationName,
                                      datetime: model.eventInvites[index].event
                                          .startDateTime,
                                      invitedBy:
                                          model.eventInvites[index].fromUser,
                                      duration: model
                                          .eventInvites[index].event.duration,
                                      onPressed: () async {
                                        var response =
                                            await model.acceptEventInvitation(
                                                context,
                                                model.eventInvites[index]);

                                        switch (response) {
                                          case GOOGLE_EVENT_OVERLAPS:
                                            buildInformationSheet(
                                              message:
                                                  AppLocalizations.of(context)!.event_invite_view_google_cal_problem_text,
                                              icon: const Icon(
                                                Icons.info,
                                                size: 50,
                                                color: Colors.blue,
                                              ),
                                            );
                                            break;
                                          case SERVICE_EVENT_EXPIRED:
                                            buildInformationSheet(
                                              message:
                                                  AppLocalizations.of(context)!.events_view_event_no_longer_available,
                                              icon: const Icon(
                                                Icons.info,
                                                size: 50,
                                                color: Colors.blue,
                                              ),
                                            );
                                            break;
                                          case SERVICE_EVENT_OVERLAPS:
                                            buildInformationSheet(
                                              message:
                                                  AppLocalizations.of(context)!.event_invite_view_event_intersects_text,
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 50,
                                                color: Colors.blue,
                                              ),
                                            );
                                            break;
                                          case SERVICE_EVENT_FULL:
                                            buildInformationSheet(
                                              message:
                                                  AppLocalizations.of(context)!.event_invite_view_full_of_members_text,
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 50,
                                                color: Colors.blue,
                                              ),
                                            );
                                            break;
                                          case SUCCESSFULLY_JOINED:
                                            buildInformationSheet(
                                              message:
                                                  AppLocalizations.of(context)!.event_invites_view_success_text,
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 50,
                                                color: Colors.blue,
                                              ),
                                            );
                                            break;
                                          default:
                                            buildInformationSheet(
                                              message: AppLocalizations.of(context)!.event_invites_view_wrong_text,
                                              icon: const Icon(
                                                Icons.error,
                                                size: 50,
                                                color: Colors.red,
                                              ),
                                            );
                                        }
                                      },
                                      accepted:
                                          model.eventInvites[index].accepted,
                                      image: model.eventInvites[index].event
                                          .sportCategory.image,
                                      processing:
                                          model.eventInvites[index].processing,
                                    )),
                        ),
                ],
              ),
            ));
  }
}
