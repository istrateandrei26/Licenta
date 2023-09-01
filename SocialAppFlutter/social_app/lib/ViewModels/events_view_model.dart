import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'package:social_app/Models/coordinates.dart';
import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/sport_category.dart';
import 'package:social_app/Models/user_coordinates.dart';
import 'package:social_app/services/events/event_hub/event_hub.dart';
import 'package:social_app/services/events/retrieve_events_response.dart';
import 'package:social_app/services/ievents_service.dart';
import 'package:social_app/user_settings.dart/user_location_info.dart';
import 'package:social_app/utilities/service_locator/locator.dart';

class EventsViewModel extends ChangeNotifier {
  List<Event> _events = [];
  List<Event> _displayedEvents = [];
  List<SportCategory> _categories = [];
  List<String> _filterAvailableCities = [];
  bool _processing = false;
  bool _processingLiveLocation = false;
  int _selectedIndex = 0;
  int _selectedDayIndex = 0;
  String selectedCity = '';

  DateTime _selectedDay = DateTime.now();
  bool _liveLocation = false;
  List<Event> _eventsNearMe = [];

  List<Event> get displayedEvents => _displayedEvents;
  List<Event> get events => _events;
  List<SportCategory> get categories => _categories;
  List<String> get filterAvailableCities => _filterAvailableCities;
  bool get processing => _processing;
  bool get processingLiveLocation => _processingLiveLocation;
  int get selectedIndex => _selectedIndex;
  int get selectedDayIndex => _selectedDayIndex;
  DateTime get selectedDay => _selectedDay;
  bool get liveLocation => _liveLocation;
  List<Event> get eventsNearMe => _eventsNearMe;
  // String get selectedCity => _selectedCity;

  final EventHub _eventHub = provider.get<EventHub>();

  EventsViewModel() {
    _eventHub.addNewEventToFeedHandler("EventsViewModelAddedEventToFeed",
        (jsonString) => onReceivedAddedEventToFeed(jsonString));
  }

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  setSelectedCity(String city) {
    selectedCity = city;
    notifyListeners();
  }

  setProcessingLiveLocation(bool processingLiveLocation) {
    _processingLiveLocation = processingLiveLocation;
    notifyListeners();
  }

  applyLiveLocationFilters() async {
    setProcessingLiveLocation(true);
    _eventsNearMe = await getEventsNearMe(events);
    applyFiltersOnEventsNearMeList();
    setProcessingLiveLocation(false);
  }

  applyCityFilteredFilters() {
    applyFiltersOnEventsList();
  }

  setLiveLocation(bool value) async {
    _liveLocation = value;
    notifyListeners();
  }

  setFilterAvailableCities(List<String> filterAvailableCities) {
    _filterAvailableCities = filterAvailableCities;
    notifyListeners();
  }

  setEvents(List<Event> events) {
    _events = events;
    notifyListeners();
  }

  setDisplayedEvents(List<Event> displayedEvents) {
    _displayedEvents = displayedEvents;
    notifyListeners();
  }

  removeEvent(int eventId) {
    _events.removeWhere((element) => element.id == eventId);
    _eventsNearMe.removeWhere((element) => element.id == eventId);
    _displayedEvents.removeWhere((element) => element.id == eventId);

    notifyListeners();
  }

  setCategories(List<SportCategory> categories) {
    _categories = categories;
    notifyListeners();
  }

  applyFiltersOnEventsNearMeList() {
    if (_selectedIndex == 0) {
      // select by day, in my range
      setDisplayedEvents(eventsNearMe
          .where((element) =>
              DateUtils.isSameDay(element.startDateTime, selectedDay))
          .toList());
    } else {
      // select by category + day, in my range
      int categoryId = _categories[_selectedIndex].id;

      setDisplayedEvents(eventsNearMe
          .where((element) =>
              element.sportCategory.id == categoryId &&
              DateUtils.isSameDay(element.startDateTime, selectedDay))
          .toList());
    }

    notifyListeners();
  }

  applyFiltersOnEventsList() {
    if (selectedCity.isNotEmpty) {
      if (_selectedIndex == 0) {
        // select by day + city
        setDisplayedEvents(events
            .where((element) =>
                DateUtils.isSameDay(element.startDateTime, selectedDay) &&
                selectedCity.trim() == element.location.city.trim())
            .toList());
      } else {
        // select by category + day + city
        int categoryId = _categories[_selectedIndex].id;

        setDisplayedEvents(events
            .where((element) =>
                element.sportCategory.id == categoryId &&
                DateUtils.isSameDay(element.startDateTime, selectedDay) &&
                selectedCity.trim() == element.location.city.trim())
            .toList());
      }
    } else {
      if (_selectedIndex == 0) {
        // select by day
        setDisplayedEvents(events
            .where((element) =>
                DateUtils.isSameDay(element.startDateTime, selectedDay))
            .toList());
      } else {
        // select by category + day
        int categoryId = _categories[_selectedIndex].id;

        setDisplayedEvents(events
            .where((element) =>
                element.sportCategory.id == categoryId &&
                DateUtils.isSameDay(element.startDateTime, selectedDay))
            .toList());
      }
    }

    notifyListeners();
  }

  setSelectedDay(int selectedDayNumber) {
    _selectedDay = DateTime.now().add(Duration(days: selectedDayNumber));
    notifyListeners();
  }

  setSelectedDayIndex(int selectedDayIndex) {
    _selectedDayIndex = selectedDayIndex;
    notifyListeners();
  }

  Future<double> getDistanceFromMyLocation(
      UserCoordinates userLocation, Coordinates to) async {
    // double distanceInMeters = GeolocatorPlatform.instance.distanceBetween(
    //     userLocation.latitude,
    //     userLocation.longitude,
    //     to.latitude,
    //     to.longitude);

    Point userLocationPoint =
        Point(userLocation.latitude, userLocation.longitude);
    Point toPoint = Point(to.latitude, to.longitude);

    double distanceInMeters =
        SphericalUtils.computeDistanceBetween(userLocationPoint, toPoint);

    return distanceInMeters / 1000.0;
  }

  List<String> getFilterAvailableCities(List<Event> events) {
    var extractedAvailableCities =
        events.map((e) => e.location.city.trim()).toSet().toList();
    extractedAvailableCities.sort();

    return extractedAvailableCities;
  }

  Future<List<Event>> getEventsNearMe(List<Event> eventList,
      {double maxDistance = 10.0}) async {
    UserLocationInfo.initializeLocationInfoForUser();
    var userLocation = UserLocationInfo.userLocation;

    List<Map<String, dynamic>> eventsNearMe = [];
    for (var event in eventList) {
      double distance = await getDistanceFromMyLocation(
          userLocation!, event.location.coordinates);

      if (distance < maxDistance) {
        eventsNearMe.add({
          'event': event,
          'distance': distance,
        });
      }
    }

    // sort by distance
    eventsNearMe.sort((a, b) {
      double d1 = a['distance'];
      double d2 = b['distance'];
      if (d1 > d2) {
        return 1;
      } else if (d1 < d2) {
        return -1;
      } else {
        return 0;
      }
    });

    return eventsNearMe.map((e) => e['event']).cast<Event>().toList();
  }

  setSelectedCategoryIndex(int selectedIndex) async {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

  addEvent(Event event) {
    _events.add(event);
    setSelectedCategoryIndex(0);
    setSelectedDayIndex(0);
    // _displayedEvents.add(event);

    //check if location exists in city filters:
    bool locationExistsInCitiesFilter = filterAvailableCities
        .any((element) => element == event.location.city.trim());

    if (!locationExistsInCitiesFilter) {
      _filterAvailableCities.add(event.location.city.trim());
      _filterAvailableCities.sort();
    }

    notifyListeners();
  }

  onReceivedAddedEventToFeed(String contentMap) {
    print(contentMap);

    var object = jsonDecode(contentMap);

    var ev = Event.fromJson(object);

    addEvent(ev);
  }

  Future<RetrieveEventsResponse?> initialize(BuildContext context) async {
    setProcessing(true);

    // if (ProfileService.signedInWithGoogle) {
    //   await Provider.of<GoogleSignInService>(context, listen: false)
    //       .getGoogleSignInProfileInfoAndUpdateProfile();
    // }

    await _eventHub.connect();

    var response = await provider.get<IEventsService>().getEvents();

    setEvents(response!.events);
    setCategories(response.categories);
    setFilterAvailableCities(getFilterAvailableCities(events));

    //  firstly, select event with any category from today
    setSelectedCategoryIndex(0); // select all
    setSelectedDay(0); // select today

    if (liveLocation) {
      _eventsNearMe = await getEventsNearMe(events);
      setDisplayedEvents(eventsNearMe); // apply filters
    } else {
      setDisplayedEvents(events); //apply filters
      applyFiltersOnEventsList();
    }
    setProcessing(false);

    return response;
  }

  @override
  void dispose() {
    _eventHub.removeNewEventToFeedHandler("EventsViewModelAddedEventToFeed");
    // _eventHub.disconnect();
    super.dispose();
  }
}
