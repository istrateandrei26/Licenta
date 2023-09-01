import 'package:flutter/material.dart';
import 'package:social_app/ViewModels/events_view_model.dart';
import 'package:social_app/components/event_card_widget.dart';
import 'package:social_app/components/event_category_widget.dart';
import 'package:social_app/components/events_view_background.dart';
import 'package:social_app/components/shimmer_widget.dart';
import 'package:social_app/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/search_location_widget.dart';
import '../components/select_day_widget.dart';
import '../components/shimmer_event_item_widget.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  Future buildSearchByLocationSheet(EventsViewModel model) =>
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
              child: SearchLocationWidget(
                  availableCities: model.filterAvailableCities,
                  handler: (searchLocationConfirmed) {
                    model.setLiveLocation(false);
                    model.setSelectedCity(searchLocationConfirmed);
                    model.applyCityFilteredFilters();
                  }),
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => EventsViewModel(),
        onModelReady: (model) => model.initialize(context),
        builder: (context, model, child) => Scaffold(
              body: Stack(
                children: <Widget>[
                  EventsViewBackground(
                    screenHeight: MediaQuery.of(context).size.height,
                  ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 130,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: ListView.builder(
                                physics: model.processing
                                    ? const NeverScrollableScrollPhysics()
                                    : const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: model.processing
                                    ? 5
                                    : model.categories.length,
                                itemBuilder: (context, index) => model
                                        .processing
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Container(
                                            height: 80,
                                            width: 80,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child:
                                                const ShimmerWidget.rectangular(
                                                    height: 80, width: 80)),
                                      )
                                    : EventCategoryWidget(
                                        item: model.categories[index],
                                        selected: model.selectedIndex == index,
                                        onTap: model.processing
                                            ? () {}
                                            : () {
                                                model.setSelectedCategoryIndex(
                                                    index);

                                                if (model.liveLocation) {
                                                  model
                                                      .applyFiltersOnEventsNearMeList();
                                                } else {
                                                  model
                                                      .applyFiltersOnEventsList();
                                                }
                                              },
                                      ),
                              )),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              physics: model.processing
                                  ? const NeverScrollableScrollPhysics()
                                  : const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 10,
                              itemBuilder: (context, index) => model.processing
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      color: Colors.transparent,
                                      child: Column(
                                        children: const [
                                          ShimmerWidget.rectangular(
                                              height: 15, width: 40),
                                          SizedBox(height: 8),
                                          ShimmerWidget.rectangular(
                                              height: 10, width: 20)
                                        ],
                                      ),
                                    )
                                  : SelectDayWidget(
                                      dayAdd: index,
                                      selected: model.selectedDayIndex == index,
                                      onTap: model.processing
                                          ? () {}
                                          : () {
                                              model.setSelectedDayIndex(index);
                                              model.setSelectedDay(index);

                                              if (model.liveLocation) {
                                                model
                                                    .applyFiltersOnEventsNearMeList();
                                              } else {
                                                model
                                                    .applyFiltersOnEventsList();
                                              }
                                            },
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListView.builder(
                              physics: model.processing
                                  ? const NeverScrollableScrollPhysics()
                                  : const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: model.processing
                                  ? 4
                                  : model.displayedEvents.length,
                              itemBuilder: (context, index) => model.processing
                                  ? const ShimmerEventItemWidget()
                                  : EventItemCard(
                                      item: model.displayedEvents[index],
                                      onTap: () {
                                        if (model.displayedEvents[index]
                                            .startDateTime
                                            .isBefore(DateTime.now())) {
                                          buildInformationSheet(
                                            message:
                                                AppLocalizations.of(context)!.events_view_event_no_longer_available,
                                            icon: const Icon(
                                              Icons.info,
                                              size: 50,
                                              color: Colors.blue,
                                            ),
                                          );

                                          model.removeEvent(
                                              model.displayedEvents[index].id);

                                          return;
                                        }

                                        Navigator.pushNamed(
                                            context, "/EventDetailsView",
                                            arguments: [
                                              model.displayedEvents[index].id,
                                              model.displayedEvents[index]
                                                  .sportCategory.image
                                            ]);
                                      },
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !model.processing,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton.small(
                              heroTag: "liveLocationButton",
                              backgroundColor: model.liveLocation
                                  ? kPrimaryColor
                                  : Colors.blue.shade300,
                              elevation: 10,
                              onPressed: () {
                                if (model.liveLocation) return;
                                model.setLiveLocation(true);
                                model.setSelectedCity('');
                                model.applyLiveLocationFilters();
                              },
                              child: model.processingLiveLocation
                                  ? const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator.adaptive(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ))
                                  : const Icon(
                                      Icons.location_searching_outlined,
                                      color: Colors.white),
                            ),
                            const SizedBox(width: 20),
                            FloatingActionButton.small(
                              heroTag: "cityFilteringButton",
                              backgroundColor: !model.liveLocation
                                  ? kPrimaryColor
                                  : Colors.blue.shade300,
                              elevation: 10,
                              onPressed: () =>
                                  buildSearchByLocationSheet(model),
                              child: const Icon(Icons.location_city,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
