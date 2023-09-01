import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Models/attended_location.dart';
import 'package:social_app/Models/location.dart';
import 'package:social_app/Models/sport_category.dart';
import 'package:social_app/Models/user_coordinates.dart';
import 'package:social_app/components/duration_list.dart';
import 'package:social_app/components/sport_icons_list.dart';
import 'package:social_app/services/events/event_hub/event_hub.dart';
import 'package:social_app/services/events/retrieve_locations_by_sport_category_response.dart';
import 'package:social_app/services/google_place_service.dart';
import 'package:social_app/services/ievents_service.dart';
import 'package:social_app/user_settings.dart/user_location_info.dart';
import 'package:social_app/utilities/service_locator/locator.dart';
import 'package:social_app/utilities/sport_category_interpreter.dart';
import 'package:social_app/services/ichat_service.dart';

import '../Models/calendar_event.dart';
import '../Models/user.dart';
import '../services/google/google_sign_in_service.dart';
import '../services/google/igoogle_calendar_service.dart';
import '../services/local_calendar_service.dart';
import '../services/local_notification_service.dart';
import '../services/profile_service.dart';
import '../user_settings.dart/user_settings.dart';

const String GOOGLE_EVENT_OVERLAPS = "GOOGLE_OVERLAPS";
const String SERVICE_EVENT_OVERLAPS = "SERVICE_OVERLAPS";
const String SERVICE_BUSY_CREATOR = "SERVICE_BUSY_CREATOR";
const String SUCCESSFULLY_CREATED = "CREATED";

class CreateEventViewModel extends ChangeNotifier {
  //search users to add to event models:
  HashSet<String> _selectedUsers = HashSet();
  final HashSet<int> _selectedUsersIds = HashSet();
  List<User> _friendListOnSearch = [];
  List<User> _friendList = [];

  List<Location> _allLocations =
      []; // here we will search selected location in order to see if we need to insert a new one
  List<Location> _availableLocations = [];
  List<Location> _availableChosenLocations = [];
  List<String> _availableCities = [];
  SportCategory _category = SportCategoryInterpreter.createSportCategoryByIndex(
      0); // init category with first selected item in icon widget list
  double _duration = duration_list[0].minutes;
  Location? _location;
  DateTime? _datetime;
  String _selectedCity = '';
  int _selectedRequiredMembers = 1;

  int _lastSelectedCategoryIndex = 0;
  int _lastSelectedLocationIndex = 0;
  int _lastSelectedCityIndex = 0;
  int _lastSelectedDurationIndex = 0;
  int _lastSelectedRequiredMembersIndex = 0;

  bool _processing = false;
  bool _updatingLiveLocation = false;
  bool _loadingInfoByCategoryId = false;
  bool _loadingUserLocation = false;
  bool _eventCreationProcessing = false;

  bool enabledCurrentLocationAnimation = false;

  // google map requirements:
  UserCoordinates? userLocation = UserLocationInfo.userLocation;
  BitmapDescriptor locationPinIcon = BitmapDescriptor.defaultMarker;
  GoogleMapController? controller;
  List<AttendedLocation> _attendedLocations = [];
  Map<String, Marker> mapMarkers = {};
  bool locationSelectedByMap = false;
  String mapCity = '';
  String mapStreet = '';
  LatLng? _stickedCoordinates;

  // google map selected coordinates with the special pin Marker
  LatLng? get selectedCoordinates => mapMarkers['pickMarker']?.position;
  LatLng? get stickedCoordinates => _stickedCoordinates;
  bool sticked = false;

  HashSet<String> get selectedUsers => _selectedUsers;
  HashSet<int> get selectedUsersIds => _selectedUsersIds;
  List<User> get friendListOnSearch => _friendListOnSearch;
  List<User> get friendList => _friendList;
  List<Location> get availableLocations => _availableLocations;
  List<Location> get availableChosenLocations => _availableChosenLocations;
  List<Location> get allLocations => _allLocations;
  List<String> get availableCities => _availableCities;
  SportCategory get selectedCategory => _category;
  Location? get selectedLocation => _location;
  String get selectedCity => _selectedCity;
  DateTime? get selectedDatetime => _datetime;
  double get selectedDuration => _duration;
  int get lastSelectedCategoryIndex => _lastSelectedCategoryIndex;
  int get lastSelectedLocationIndex => _lastSelectedLocationIndex;
  int get lastSelectedCityIndex => _lastSelectedCityIndex;
  int get lastSelectedDurationIndex => _lastSelectedDurationIndex;
  int get selectedRequiredMembers => _selectedRequiredMembers;
  int get lastSelectedRequiredMembersIndex => _lastSelectedRequiredMembersIndex;
  bool get processing => _processing;
  bool get updatingLiveLocation => _updatingLiveLocation;
  bool get loadingInfoByCategoryId => _loadingInfoByCategoryId;
  bool get loadingUserLocation => _loadingUserLocation;
  bool get eventCreationProcessing => _eventCreationProcessing;
  List<AttendedLocation> get attendedLocations => _attendedLocations;

  final EventHub _eventHub = provider.get<EventHub>();

  // BE AWARE OF THIS WHEN YOU TEST !!!!!!!!!!!!!!!!!!!!

  clearSelectedUsers() {
    _selectedUsersIds.clear();
    _selectedUsers.clear();
    notifyListeners();
  }

  // ........................................................

  Future addCustomIconToLocationPicker() async {
    var iconValue = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(20, 20)),
        'assets/icons/pin-point.png');
    locationPinIcon = iconValue;
    notifyListeners();
  }

  SportCategory? getSportCategoryOfMapMarkerLocation(LatLng mapMarker) {
    var exists = attendedLocations.any((element) =>
        element.location.coordinates.latitude == mapMarker.latitude &&
        element.location.coordinates.longitude == mapMarker.longitude);

    if (exists) {
      var category = attendedLocations
          .firstWhere((element) =>
              element.location.coordinates.latitude == mapMarker.latitude &&
              element.location.coordinates.longitude == mapMarker.longitude)
          .sportCategory;

      return category;
    }

    return null;
  }

  void onCameraIdle() async {
    if (!enabledCurrentLocationAnimation) {
      LatLng specialMarkerPosition = mapMarkers['pickMarker']!.position;
      double minDistance = double.infinity;
      // ignore: unused_local_variable
      LatLng closestMarkerPosition =
          LatLng(userLocation!.latitude, userLocation!.longitude);

      for (Marker marker in mapMarkers.values) {
        if (marker.markerId.value != 'pickMarker') {
          double distance = Geolocator.distanceBetween(
            specialMarkerPosition.latitude,
            specialMarkerPosition.longitude,
            marker.position.latitude,
            marker.position.longitude,
          );

          if (distance < minDistance) {
            minDistance = distance;
            closestMarkerPosition = marker.position;
          }
        }
      }

      if (minDistance < 2) return;

      if (minDistance <= 400) {
        setSticked(true);
        controller?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: closestMarkerPosition,
            zoom: 15.0,
          ),
        ));

        setStickedCoordinates(closestMarkerPosition);
      } else {
        setSticked(false);
      }
    }
  }

  void goToCurrentLocation() async {
    enabledCurrentLocationAnimation = true;
    await updateLiveLocation();
    controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(userLocation!.latitude, userLocation!.longitude),
        zoom: 15.0,
      ),
    ));

    await Future.delayed(const Duration(seconds: 3));

    enabledCurrentLocationAnimation = false;
  }

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  setLocationSelectedByMap(bool value) {
    notifyListeners();
  }

  setLoadingInfoByCategoryId(bool value) {
    _loadingInfoByCategoryId = value;
    notifyListeners();
  }

  setUpdatingLiveLocation(bool value) {
    _updatingLiveLocation = value;
    notifyListeners();
  }

  setLoadingUserLocation(bool value) {
    _loadingUserLocation = value;
    notifyListeners();
  }

  setEventCreationProcessing(bool eventCreationProcessing) {
    _eventCreationProcessing = eventCreationProcessing;
    notifyListeners();
  }

  initializeMapMarkers(List<AttendedLocation> attendedLocations) async {
    for (var historyLocation in attendedLocations) {
      var dbIconCorrectPath =
          "${historyLocation.sportCategory.image.replaceFirst('/event_card_images', '').replaceFirst("images", "icons_resized").split(".")[0]}.png";
      var iconValue = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(20, 20)), dbIconCorrectPath);

      Marker newMarker = Marker(
        markerId: MarkerId(
            "${historyLocation.location.city} ${historyLocation.location.locationName}"),
        position: LatLng(historyLocation.location.coordinates.latitude,
            historyLocation.location.coordinates.longitude),
        icon: iconValue,
        infoWindow: InfoWindow(
          title:
              "${historyLocation.location.city} ${historyLocation.location.locationName}",
          snippet: 'You played here!',
        ),
      );

      mapMarkers[newMarker.markerId.value] = newMarker;
    }

    var pickMarker = Marker(
        markerId: const MarkerId('pickMarker'),
        position: LatLng(userLocation!.latitude, userLocation!.longitude),
        icon: locationPinIcon,
        zIndex: 1);

    mapMarkers[pickMarker.markerId.value] = pickMarker;

    notifyListeners();
  }

  setSticked(bool value) {
    sticked = value;
    notifyListeners();
  }

  setStickedCoordinates(LatLng stickedCoordinates) {
    _stickedCoordinates = stickedCoordinates;
    notifyListeners();
  }

  setAllLocations(List<Location> allLocations) {
    var attendedLoc = attendedLocations
        .map((e) => Location(e.location.id, e.location.city,
            e.location.locationName, e.location.coordinates, false))
        .toList();

    _allLocations = allLocations;
    _allLocations.addAll(attendedLoc.toList());

    notifyListeners();
  }

  setAttendedLocations(List<AttendedLocation> attendedLocations) {
    _attendedLocations = attendedLocations;
    notifyListeners();
  }

  setSelectedUsers(HashSet<String> selectedUsers) {
    _selectedUsers = selectedUsers;
    notifyListeners();
  }

  setFriendListOnSearch(List<User> friendListOnSearch) {
    _friendListOnSearch = friendListOnSearch;
    notifyListeners();
  }

  setFriendList(List<User> friendList) {
    _friendList = friendList;
    notifyListeners();
  }

  setSelectedRequiredMembers(int selectedRequiredMembers) {
    _selectedRequiredMembers = selectedRequiredMembers;
    notifyListeners();
  }

  setLastSelectedRequiredMembersIndex(int lastSelectedRequiredMembersIndex) {
    _lastSelectedRequiredMembersIndex = lastSelectedRequiredMembersIndex;
    notifyListeners();
  }

  setLastSelectedCategoryIndex(int lastSelectedCategoryIndex) {
    _lastSelectedCategoryIndex = lastSelectedCategoryIndex;
    notifyListeners();
  }

  setLastSelectedDurationIndex(int lastSelectedDurationIndex) {
    _lastSelectedDurationIndex = lastSelectedDurationIndex;
    notifyListeners();
  }

  setLastSelectedLocationIndex(int lastSelectedLocationIndex) {
    _lastSelectedLocationIndex = lastSelectedLocationIndex;
    notifyListeners();
  }

  setLastSelectedCityIndex(int lastSelectedCityIndex) {
    _lastSelectedCityIndex = lastSelectedCityIndex;
    notifyListeners();
  }

  setSelectedCategory(SportCategory selectedCategory) {
    _category = selectedCategory;
    notifyListeners();
  }

  setSelectedLocation(Location? selectedLocation) {
    _location = selectedLocation;

    // availableLocations.remove(selectedLocation);
    // availableLocations.insert(0, selectedLocation!);

    notifyListeners();
  }

  setSelectedCity(String selectedCity) {
    _selectedCity = selectedCity;
    notifyListeners();
  }

  setSelectedDatetime(DateTime? selectedDatetime) {
    _datetime = selectedDatetime;
    notifyListeners();
  }

  setAvailableLocations(List<Location> availableLocations) {
    _availableLocations = availableLocations;
    notifyListeners();
  }

  setAvailableChosenLocations(List<Location> availableChosenLocations) {
    _availableChosenLocations = availableChosenLocations;
    notifyListeners();
  }

  setAvailableCities(List<String> availableCities) {
    _availableCities = availableCities.toSet().toList();
    notifyListeners();
  }

  setDuration(double duration) {
    _duration = duration;
    notifyListeners();
  }

  setMapCityAndStreet() async {
    var locationInfo = await GooglePlaceService.getLocationInfoByCoordinates(
        selectedCoordinates!.latitude, selectedCoordinates!.longitude);

    mapCity = locationInfo.city;
    mapStreet = locationInfo.locationName;

    notifyListeners();

    if (sticked) {
      var foundSportCategory =
          getSportCategoryOfMapMarkerLocation(stickedCoordinates!);

      if (foundSportCategory != null) {
        setSelectedCategory(foundSportCategory);
        setLastSelectedCategoryIndex(icon_list
            .lastIndexWhere((element) => element.id == foundSportCategory.id));
      }
    }
  }

  bool mapSelectedLocationExists(LatLng selectedCoordinates) {
    bool exists = allLocations.any((element) =>
        element.coordinates.latitude == selectedCoordinates.latitude &&
        element.coordinates.longitude == selectedCoordinates.longitude);

    return exists;
  }

  Future addGoogleCalendarEvent(
      String sportCategoryName,
      String city,
      String locationName,
      DateTime startDateTime,
      double duration,
      int eventId,
      String accessToken) async {
    var event = CalendarEvent(
        "$sportCategoryName, $locationName",
        startDateTime,
        startDateTime.add(Duration(minutes: duration.toInt())),
        "$locationName, $city");

    var googleCalendarEventId = await provider
        .get<IGoogleCalendarService>()
        .insertEventIntoCalendar(accessToken, event);

    await provider.get<IEventsService>().addGoogleCalendarEvent(
        googleCalendarEventId!, ProfileService.userId!, eventId);
  }

  Future initializeInfoBySportCategory() async {
    // setLoadingInfoByCategoryId(true);

    _eventHub.connect();

    locationSelectedByMap = false;
    setDuration(duration_list[0].minutes);
    setLastSelectedCityIndex(0);
    setLastSelectedDurationIndex(0);
    setLastSelectedLocationIndex(0);

    var response = await provider
        .get<IEventsService>()
        .getLocationsBySportCategory(
            ProfileService.userId!, selectedCategory.id);

    setAvailableLocations(
        response!.locations.where((element) => !(element.mapChosen)).toList());
    setAvailableCities(response.locations
        .where((element) => !(element.mapChosen))
        .map((e) => e.city.trim())
        .toList());
    setSelectedCity(availableCities[0]);
    setSelectedLocation(availableLocations
        .firstWhere((element) => element.city == selectedCity));
    setAvailableChosenLocations(availableLocations
        .where((element) => element.city == selectedCity)
        .toList());
    setLastSelectedRequiredMembersIndex(0);
    setSelectedDatetime(DateTime.now().add(
      Duration(minutes: 90 - DateTime.now().minute % 30),
    ));
    setSelectedRequiredMembers(icon_list
        .firstWhere((element) => element.id == selectedCategory.id)
        .requiredMembers[lastSelectedRequiredMembersIndex]);

    setAttendedLocations(response.attendedLocations);

    setAllLocations(response.locations);

    var friendsResponse = await provider
        .get<IChatService>()
        .getFriends(ProfileService.userId!); //change!

    setFriendList(friendsResponse!.friends);

    await addCustomIconToLocationPicker();
    initializeMapMarkers(attendedLocations);

    // setLoadingInfoByCategoryId(false);
  }

  Future updateLiveLocation() async {
    setUpdatingLiveLocation(true);

    UserLocationInfo.initializeLocationInfoForUser();
    userLocation = UserLocationInfo.userLocation;

    setUpdatingLiveLocation(false);
  }

  Future initializeUserLocation() async {
    setLoadingUserLocation(true);

    UserLocationInfo.initializeLocationInfoForUser();
    userLocation = UserLocationInfo.userLocation;

    setLoadingUserLocation(false);
  }

  Future<RetrieveLocationsBySportCategoryResponse?> initialize() async {
    setProcessing(true);

    _eventHub.connect();

    var response = await provider
        .get<IEventsService>()
        .getLocationsBySportCategory(
            ProfileService.userId!, selectedCategory.id);

    // test these lines:
    setAllLocations(response!.locations);
    setAvailableLocations(
        response.locations.where((element) => !(element.mapChosen)).toList());
    setAvailableCities(response.locations
        .where((element) => !(element.mapChosen))
        .map((e) => e.city.trim())
        .toList());
    setSelectedCity(availableCities[0]);
    setSelectedLocation(availableLocations
        .firstWhere((element) => element.city == selectedCity));
    setAvailableChosenLocations(availableLocations
        .where((element) => element.city == selectedCity)
        .toList());
    setLastSelectedRequiredMembersIndex(0);
    setSelectedDatetime(DateTime.now().add(
      Duration(minutes: 90 - DateTime.now().minute % 30),
    ));
    setSelectedRequiredMembers(icon_list
        .firstWhere((element) => element.id == selectedCategory.id)
        .requiredMembers[lastSelectedRequiredMembersIndex]);

    var attendedLocationsResponse = await provider
        .get<IEventsService>()
        .getAttendedLocations(ProfileService.userId!);

    setAttendedLocations(attendedLocationsResponse!.attendedLocations);
    // userLocation = await LocationService.getUserLocation();
    await addCustomIconToLocationPicker();
    initializeMapMarkers(attendedLocations);

    // var friendsResponse = await provider
    //     .get<IChatService>()
    //     .getFriends(ProfileService.userId!); //change!

    // setFriendList(friendsResponse!.friends);

    setProcessing(false);

    return response;
  }

  Future<String?> createEvent(BuildContext context) async {
    setProcessing(true);

    setEventCreationProcessing(true);

    if (!selectedUsersIds.contains(ProfileService.userId!)) {
      selectedUsersIds.add(ProfileService.userId!);
    }

    var startTime = selectedDatetime;
    var endTime = startTime!.add(Duration(minutes: selectedDuration.toInt()));

    late int locationId;
    double lat = 0.0;
    double lng = 0.0;
    String city = '';
    String locationName = '';
    bool createNewLocation = false;

    if (locationSelectedByMap) {
      bool locationExists = false;
      // verify if we need to insert new location first
      if (stickedCoordinates != null && sticked) {
        locationExists = mapSelectedLocationExists(stickedCoordinates!);
      }

      if (!locationExists) {
        var locationInfo =
            await GooglePlaceService.getLocationInfoByCoordinates(
                selectedCoordinates!.latitude, selectedCoordinates!.longitude);
        // var createLocationResponse = await provider
        //     .get<IEventsService>()
        //     .createNewLocation(locationInfo.lat, locationInfo.lng,
        //         locationInfo.city, locationInfo.locationName);

        createNewLocation = true;
        lat = locationInfo.lat;
        lng = locationInfo.lng;
        city = locationInfo.city;
        locationName = locationInfo.locationName;
        locationId = -1;
      } else {
        locationId = allLocations
            .firstWhere((element) =>
                element.coordinates.latitude == stickedCoordinates!.latitude &&
                element.coordinates.longitude == stickedCoordinates!.longitude)
            .id;

        createNewLocation = false;
      }
    } else {
      locationId = selectedLocation!.id;
      createNewLocation = false;
      locationName =
          '${selectedLocation!.city.trim()}, ${selectedLocation!.locationName.trim()}';
    }

    if (ProfileService.signedInWithGoogle &&
        UserSettings.googleCalendarEnabled) {
      var googleAccount =
          Provider.of<GoogleSignInService>(context, listen: false).user;
      var authHeader = (await googleAccount?.authentication)!;

      bool overlaps = await provider
          .get<IGoogleCalendarService>()
          .checkOverlapEvent(authHeader.accessToken!, startTime, endTime);

      if (overlaps) {
        // show modal bottom to notify the Google Calendar event overlaps with another event
        setEventCreationProcessing(false);
        return GOOGLE_EVENT_OVERLAPS;
      } else {
        //try to create event in database:
        var response = (await provider.get<IEventsService>().createEvent(
            selectedCategory.id,
            locationId,
            ProfileService.userId!, //profile ID !!!!!!!!!!!!!!!!!!!!!!!!!!
            icon_list
                .firstWhere((element) => element.id == selectedCategory.id)
                .requiredMembers[lastSelectedRequiredMembersIndex],
            selectedUsersIds.toList(),
            startTime,
            selectedDuration,
            createNewLocation,
            lat: lat,
            long: lng,
            city: city,
            locationName: locationName))!;

        if (response.busyCreator) {
          setEventCreationProcessing(false);
          return SERVICE_BUSY_CREATOR;
        }

        if (response.overlaps) {
          setEventCreationProcessing(false);
          return SERVICE_EVENT_OVERLAPS;
        }

        await addGoogleCalendarEvent(
            selectedCategory.name.trim(),
            city,
            locationName,
            startTime,
            selectedDuration,
            response.eventId,
            authHeader.accessToken!);

        if (response.successfullyCreated) {
          _eventHub.addNewEventToFeed(response.eventId,
              selectedUsersIds.toList(), ProfileService.userId!);
        }
        setEventCreationProcessing(false);
        return SUCCESSFULLY_CREATED;
      }
    } else if (ProfileService.signedInWithGoogle &&
        !UserSettings.googleCalendarEnabled &&
        UserSettings.localCalendarEnabled) {
      //try to create event in database:
      var response = (await provider.get<IEventsService>().createEvent(
          selectedCategory.id,
          locationId,
          ProfileService.userId!, //profile ID !!!!!!!!!!!!!!!!!!!!!!!!!!
          icon_list
              .firstWhere((element) => element.id == selectedCategory.id)
              .requiredMembers[lastSelectedRequiredMembersIndex],
          selectedUsersIds.toList(),
          startTime,
          selectedDuration,
          createNewLocation,
          lat: lat,
          long: lng,
          city: city,
          locationName: locationName))!;

      if (response.busyCreator) {
        setEventCreationProcessing(false);
        return SERVICE_BUSY_CREATOR;
      }

      if (response.overlaps) {
        setEventCreationProcessing(false);
        return SERVICE_EVENT_OVERLAPS;
      }

      if (response.successfullyCreated) {
        _eventHub.addNewEventToFeed(response.eventId, selectedUsersIds.toList(),
            ProfileService.userId!);
      }
      setEventCreationProcessing(false);
      // the event has been successfully inserted into Events Service, so now we can insert it into Local Calendar
      LocalCalendarService().addEventToLocalCalendar(locationName.trim(),
          selectedCategory.name.trim(), startTime, selectedDuration);
      return SUCCESSFULLY_CREATED;
    } else if (ProfileService.signedInWithGoogle &&
        !UserSettings.googleCalendarEnabled &&
        !UserSettings.localCalendarEnabled) {
      //try to create event in database:
      var response = (await provider.get<IEventsService>().createEvent(
          selectedCategory.id,
          locationId,
          ProfileService.userId!, //profile ID !!!!!!!!!!!!!!!!!!!!!!!!!!
          icon_list
              .firstWhere((element) => element.id == selectedCategory.id)
              .requiredMembers[lastSelectedRequiredMembersIndex],
          selectedUsersIds.toList(),
          startTime,
          selectedDuration,
          createNewLocation,
          lat: lat,
          long: lng,
          city: city,
          locationName: locationName))!;

      if (response.busyCreator) {
        setEventCreationProcessing(false);
        return SERVICE_BUSY_CREATOR;
      }

      if (response.overlaps) {
        setEventCreationProcessing(false);
        return SERVICE_EVENT_OVERLAPS;
      }

      // schedule notification, if user has not google calendar enabled:
      LocalNotificationService().scheduleNotification(
          title: "${selectedCategory.name.trim()}, ${locationName.trim()}",
          body: "Don't forget to be there !",
          scheduledNotificationDateTime:
              startTime.subtract(const Duration(minutes: 60)));

      if (response.successfullyCreated) {
        _eventHub.addNewEventToFeed(response.eventId, selectedUsersIds.toList(),
            ProfileService.userId!);
      }
      setEventCreationProcessing(false);
      return SUCCESSFULLY_CREATED;
    }

    if (!ProfileService.signedInWithGoogle &&
        UserSettings.localCalendarEnabled) {
      //try to create event in database:
      var response = (await provider.get<IEventsService>().createEvent(
          selectedCategory.id,
          locationId,
          ProfileService.userId!, //profile ID !!!!!!!!!!!!!!!!!!!!!!!!!!
          icon_list
              .firstWhere((element) => element.id == selectedCategory.id)
              .requiredMembers[lastSelectedRequiredMembersIndex],
          selectedUsersIds.toList(),
          startTime,
          selectedDuration,
          createNewLocation,
          lat: lat,
          long: lng,
          city: city,
          locationName: locationName))!;

      if (response.busyCreator) {
        setEventCreationProcessing(false);
        return SERVICE_BUSY_CREATOR;
      }

      if (response.overlaps) {
        setEventCreationProcessing(false);
        return SERVICE_EVENT_OVERLAPS;
      }

      // schedule notification, if user has not google calendar enabled:
      LocalNotificationService().scheduleNotification(
          title: "${selectedCategory.name.trim()}, ${locationName.trim()}",
          body: "Don't forget to be there !",
          scheduledNotificationDateTime:
              startTime.subtract(const Duration(minutes: 60)));
      if (response.successfullyCreated) {
        _eventHub.addNewEventToFeed(response.eventId, selectedUsersIds.toList(),
            ProfileService.userId!);
      }
      setEventCreationProcessing(false);
      // the event has been successfully inserted into Events Service, so now we can insert it into Local Calendar
      LocalCalendarService().addEventToLocalCalendar(locationName.trim(),
          selectedCategory.name.trim(), startTime, selectedDuration);
      return SUCCESSFULLY_CREATED;
    } else if (!ProfileService.signedInWithGoogle &&
        !UserSettings.localCalendarEnabled) {
      //try to create event in database:
      var response = (await provider.get<IEventsService>().createEvent(
          selectedCategory.id,
          locationId,
          ProfileService.userId!, //profile ID !!!!!!!!!!!!!!!!!!!!!!!!!!
          icon_list
              .firstWhere((element) => element.id == selectedCategory.id)
              .requiredMembers[lastSelectedRequiredMembersIndex],
          selectedUsersIds.toList(),
          startTime,
          selectedDuration,
          createNewLocation,
          lat: lat,
          long: lng,
          city: city,
          locationName: locationName))!;

      if (response.busyCreator) {
        setEventCreationProcessing(false);
        return SERVICE_BUSY_CREATOR;
      }

      if (response.overlaps) {
        setEventCreationProcessing(false);
        return SERVICE_EVENT_OVERLAPS;
      }

      //  schedule notification, if user has not google calendar enabled:
      LocalNotificationService().scheduleNotification(
          title: "${selectedCategory.name.trim()}, ${locationName.trim()}",
          body: "Don't forget to be there !",
          scheduledNotificationDateTime:
              startTime.subtract(const Duration(minutes: 60)));
      if (response.successfullyCreated) {
        _eventHub.addNewEventToFeed(response.eventId, selectedUsersIds.toList(),
            ProfileService.userId!);
      }

      setEventCreationProcessing(false);
      return SUCCESSFULLY_CREATED;
    }

    setEventCreationProcessing(false);

    setProcessing(false);

    return null;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
