import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Models/calendar_event.dart';
import 'package:social_app/Models/coordinates.dart';
import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/event_details.dart';
import 'package:social_app/Models/user.dart';
import 'package:social_app/services/chat/chat_hub/chat_hub.dart';
import 'package:social_app/services/directions_service.dart';
import 'package:social_app/services/events/retrieve_event_details_response.dart';
import 'package:social_app/services/google/google_sign_in_service.dart';
import 'package:social_app/services/google/igoogle_calendar_service.dart';
import 'package:social_app/services/ievents_service.dart';
import 'package:social_app/services/local_notification_service.dart';
import 'package:social_app/user_settings.dart/user_location_info.dart';
import 'package:social_app/user_settings.dart/user_settings.dart';
import 'package:social_app/utilities/service_locator/locator.dart';

import '../Models/directions.dart';
import '../services/events/event_hub/event_hub.dart';
import '../services/local_calendar_service.dart';
import '../services/profile_service.dart';
import 'event_invites_view_model.dart';

class EventDetailsViewModel extends ChangeNotifier {
  Event? _event;
  List<User> _members = [];
  List<User> _friends = [];
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(45.443740, 28.028646), zoom: 14.4746);
  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;
  bool _processing = false;
  bool _joiningEvent = false;
  bool _quittingEvent = false;

  final EventHub _eventHub = provider.get<EventHub>();

  Event? get event => _event;
  EventDetails get eventDetails => EventDetails(event, members);
  List<User> get members => _members;
  List<User> get friends => _friends;
  bool get joiningEvent => _joiningEvent;
  bool get quittingEvent => _quittingEvent;

  CameraPosition get initialCameraPosition => _initialCameraPosition;
  GoogleMapController? get googleMapController => _googleMapController;
  Marker? get origin => _origin;
  Marker? get destination => _destination;
  Directions? get info => _info;

  bool get processing => _processing;

  EventDetailsViewModel() {
    _eventHub.addNotifyAddedMemberToEventHandler(
        "EventDetailsViewModelAddedMemberToEventHandler",
        (newMemberInfo, eventId) =>
            onReceivedAddedMemberToEventNotification(newMemberInfo, eventId));

    _eventHub.addNotifyMemberQuitedEventHandler(
        "EventDetailsViewModelMemberQuitedEventHandler",
        (memberId, eventId) =>
            onReceivedMemberQuitedEventNotification(memberId, eventId));

    provider.get<ChatHub>().addCreatedNewConversationWithFriend(
        "EventDetailsViewModelCreatedNewConversationWithFriendHandler",
        (content, newNumberOfFriends, friendRequestId, newFriendContent) =>
            onCreatedNewConversationWithFriend(content, newNumberOfFriends,
                friendRequestId, newFriendContent));
  }

  setOrigin(double latitude, double longitude) {
    _origin = Marker(
        markerId: const MarkerId("origin"),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(latitude, longitude),
        visible: false);
  }

  setDestination(Coordinates coordinates) {
    _destination = Marker(
        markerId: const MarkerId("destination"),
        infoWindow: InfoWindow(title: event!.location.locationName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(coordinates.latitude, coordinates.longitude));
  }

  setGoogleMapController(GoogleMapController controller) {
    _googleMapController = controller;
  }

  setQuittingEvent(bool quittingEvent) async {
    _quittingEvent = quittingEvent;
    notifyListeners();
  }

  setJoiningEvent(bool joiningEvent) async {
    _joiningEvent = joiningEvent;
    notifyListeners();
  }

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  setEvent(Event? event) {
    _event = event;
    notifyListeners();
  }

  setMembers(List<User> members) {
    _members = members;
    notifyListeners();
  }

  setFriends(List<User> friends) {
    _friends = friends;
    notifyListeners();
  }

  addFriend(User friend) {
    _friends.add(friend);
    notifyListeners();
  }

  addMember(User newMember) {
    _members.add(newMember);
    notifyListeners();
  }

  removeMember(int memberId) {
    _members.removeWhere((element) => element.id == memberId);
    notifyListeners();
  }

  List<User> getFriendsWhichAreNotMembers() {
    List<User> result = [];
    for (var element in friends) {
      if (!members.map((e) => e.id).contains(element.id)) {
        result.add(element);
      }
    }

    return result;
  }

  Future<RetrieveEventDetailsResponse?> initialize(int eventId) async {
    setProcessing(true);

    await _eventHub.connect();

    var response = await provider
        .get<IEventsService>()
        .getEventDetails(eventId, ProfileService.userId!);

    setEvent(response!.event);
    setMembers(response.members);
    setFriends(response.friends);

    await UserLocationInfo.initializeLocationInfoForUser();

    var userLocation = UserLocationInfo.userLocation!;

    setOrigin(userLocation.latitude, userLocation.longitude);
    setDestination(response.event.location.coordinates);

    _info = await DirectionsService()
        .getDirections(_origin!.position, _destination!.position);

    setProcessing(false);

    return response;
  }

  Future addGoogleCalendarEvent(
      BuildContext context, Event eventToBeAdded, String accessToken) async {
    var event = CalendarEvent(
        "${eventToBeAdded.sportCategory.name.trim()}, ${eventToBeAdded.location.locationName.trim()}",
        eventToBeAdded.startDateTime,
        eventToBeAdded.startDateTime
            .add(Duration(minutes: eventToBeAdded.duration.toInt())),
        "${eventToBeAdded.location.locationName}, ${eventToBeAdded.location.city}");

    var googleCalendarEventId = await provider
        .get<IGoogleCalendarService>()
        .insertEventIntoCalendar(accessToken, event);

    await provider.get<IEventsService>().addGoogleCalendarEvent(
        googleCalendarEventId!, ProfileService.userId!, eventToBeAdded.id);
  }

  Future deleteGoogleCalendarEvent(BuildContext context,
      String googleCalendarEventId, String accessToken) async {
    await provider
        .get<IGoogleCalendarService>()
        .deleteEventFromCalendar(accessToken, googleCalendarEventId);
  }

  Future<String?> joinEvent(
      BuildContext context, int memberId, int eventId) async {
    setJoiningEvent(true);

    var startTime = _event!.startDateTime;
    var endTime =
        _event!.startDateTime.add(Duration(minutes: _event!.duration.toInt()));

    //  check if user is Signed In With Google.
    //  If so, check is Google calendar feature is enabled and if it's not, use OS calendar function
    //  IF not, use OS calendar function

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
        setJoiningEvent(false);
        return GOOGLE_EVENT_OVERLAPS;
      } else {
        //  try to accept event invitation in database:
        var response = (await provider
            .get<IEventsService>()
            .checkEventToJoin(eventId, ProfileService.userId!))!;
        // check in response if event was expired or busy:
        if (response.expired) {
          setJoiningEvent(false);
          return SERVICE_EVENT_EXPIRED;
        }

        if (response.full) {
          setJoiningEvent(false);
          return SERVICE_EVENT_FULL;
        }

        if (response.busy) {
          setJoiningEvent(false);
          return SERVICE_EVENT_OVERLAPS;
        }
        // the event has been successfully inserted into Events Service, so now we can insert it into Google Calendar
        // ignore: use_build_context_synchronously
        await addGoogleCalendarEvent(context, _event!, authHeader.accessToken!);

        await _eventHub.addMemberToEvent(ProfileService.userId!, _event!.id);
        addMember(User(
            ProfileService.userId,
            ProfileService.email,
            ProfileService.firstname,
            ProfileService.lastname,
            ProfileService.profileImage));
        setJoiningEvent(false);
        return SUCCESSFULLY_JOINED;
      }
    } else if (ProfileService.signedInWithGoogle &&
        !UserSettings.googleCalendarEnabled &&
        UserSettings.localCalendarEnabled) {
      //  try to accept event invitation in database:
      var response = (await provider
          .get<IEventsService>()
          .checkEventToJoin(eventId, ProfileService.userId!))!;
      // check in response if event was expired or busy:
      if (response.expired) {
        setJoiningEvent(false);
        return SERVICE_EVENT_EXPIRED;
      }

      if (response.full) {
        setJoiningEvent(false);
        return SERVICE_EVENT_FULL;
      }

      if (response.busy) {
        setJoiningEvent(false);
        return SERVICE_EVENT_OVERLAPS;
      }

      await _eventHub.addMemberToEvent(ProfileService.userId!, _event!.id);
      addMember(User(
          ProfileService.userId,
          ProfileService.email,
          ProfileService.firstname,
          ProfileService.lastname,
          ProfileService.profileImage));
      setJoiningEvent(false);
      // the event has been successfully inserted into Events Service, so now we can insert it into Local Calendar
      LocalCalendarService().addEventToLocalCalendar(
          _event!.location.locationName.trim(),
          _event!.sportCategory.name.trim(),
          startTime,
          _event!.duration);

      return SUCCESSFULLY_JOINED;
    } else if (ProfileService.signedInWithGoogle &&
        !UserSettings.googleCalendarEnabled &&
        !UserSettings.localCalendarEnabled) {
      //  try to accept event invitation in database:
      var response = (await provider
          .get<IEventsService>()
          .checkEventToJoin(eventId, ProfileService.userId!))!;
      // check in response if event was expired or busy:
      if (response.expired) {
        setJoiningEvent(false);
        return SERVICE_EVENT_EXPIRED;
      }

      if (response.full) {
        setJoiningEvent(false);
        return SERVICE_EVENT_FULL;
      }

      if (response.busy) {
        setJoiningEvent(false);
        return SERVICE_EVENT_OVERLAPS;
      }

      await _eventHub.addMemberToEvent(ProfileService.userId!, _event!.id);
      // the event has been successfully inserted into Events Service
      addMember(User(
          ProfileService.userId,
          ProfileService.email,
          ProfileService.firstname,
          ProfileService.lastname,
          ProfileService.profileImage));
      setJoiningEvent(false);
      return SUCCESSFULLY_JOINED;
    }

    if (!ProfileService.signedInWithGoogle &&
        UserSettings.localCalendarEnabled) {
      //  try to accept event invitation in database:
      var response = (await provider
          .get<IEventsService>()
          .checkEventToJoin(eventId, ProfileService.userId!))!;
      // check in response if event was expired or busy:
      if (response.expired) {
        setJoiningEvent(false);
        return SERVICE_EVENT_EXPIRED;
      }

      if (response.full) {
        setJoiningEvent(false);
        return SERVICE_EVENT_FULL;
      }

      if (response.busy) {
        setJoiningEvent(false);
        return SERVICE_EVENT_OVERLAPS;
      }

      //  schedule notification, if user has not google calendar enabled:
      LocalNotificationService().scheduleNotification(
          title:
              "${_event!.sportCategory.name.trim()}, ${_event!.location.locationName.trim()}",
          body: "Don't forget to be there !",
          scheduledNotificationDateTime:
              startTime.subtract(const Duration(minutes: 60)));

      await _eventHub.addMemberToEvent(ProfileService.userId!, _event!.id);
      addMember(User(
          ProfileService.userId,
          ProfileService.email,
          ProfileService.firstname,
          ProfileService.lastname,
          ProfileService.profileImage));
      setJoiningEvent(false);
      // the event has been successfully inserted into Events Service, so now we can insert it into Local Calendar
      LocalCalendarService().addEventToLocalCalendar(
          _event!.location.locationName.trim(),
          _event!.sportCategory.name.trim(),
          startTime,
          _event!.duration);

      return SUCCESSFULLY_JOINED;
    } else if (!ProfileService.signedInWithGoogle &&
        !UserSettings.localCalendarEnabled) {
      //  try to accept event invitation in database:
      var response = (await provider
          .get<IEventsService>()
          .checkEventToJoin(eventId, ProfileService.userId!))!;
      // check in response if event was expired or busy:
      if (response.expired) {
        setJoiningEvent(false);
        return SERVICE_EVENT_EXPIRED;
      }

      if (response.full) {
        setJoiningEvent(false);
        return SERVICE_EVENT_FULL;
      }

      if (response.busy) {
        setJoiningEvent(false);
        return SERVICE_EVENT_OVERLAPS;
      }

      //  schedule notification, if user has not google calendar enabled:
      LocalNotificationService().scheduleNotification(
          title:
              "${_event!.sportCategory.name.trim()}, ${_event!.location.locationName.trim()}",
          body: "Don't forget to be there !",
          scheduledNotificationDateTime:
              startTime.subtract(const Duration(minutes: 60)));

      await _eventHub.addMemberToEvent(ProfileService.userId!, _event!.id);

      addMember(User(
          ProfileService.userId,
          ProfileService.email,
          ProfileService.firstname,
          ProfileService.lastname,
          ProfileService.profileImage));
      setJoiningEvent(false);
      return SUCCESSFULLY_JOINED;
    }

    setJoiningEvent(false);

    return null;
  }

  Future quitEvent(BuildContext context) async {
    setQuittingEvent(true);

    // check if there is a corresponding google calendar event for user
    var googleCalendarEventId = (await provider
        .get<IEventsService>()
        .getGoogleCalendarEventId(ProfileService.userId!, _event!.id))!;

    // delete google calendar event, there is no problem if it does not exits, it is handled in backend
    await provider
        .get<IEventsService>()
        .removeGoogleCalendarEvent(ProfileService.userId!, _event!.id);

    if (ProfileService.signedInWithGoogle) {
      var googleAccount =
          // ignore: use_build_context_synchronously
          Provider.of<GoogleSignInService>(context, listen: false).user;
      var authHeader = (await googleAccount?.authentication)!;

      if (googleCalendarEventId.found) {
        // ignore: use_build_context_synchronously
        await deleteGoogleCalendarEvent(
            context, googleCalendarEventId.id, authHeader.accessToken!);
      }
    }

    LocalNotificationService().deleteScheduledNotification(_event!.id);

    await provider
        .get<EventHub>()
        .removeMemberFromEvent(ProfileService.userId!, event!.id);

    removeMember(ProfileService.userId!);

    setQuittingEvent(false);
  }

  onReceivedAddedMemberToEventNotification(String newMemberInfo, int eventId) {
    if (eventId != event!.id) return;

    var newMember = User.fromJson(jsonDecode(newMemberInfo));

    addMember(newMember);
  }

  onReceivedMemberQuitedEventNotification(int memberId, eventId) {
    if (eventId != event!.id) return;

    removeMember(memberId);
  }

  onCreatedNewConversationWithFriend(String content, int newNumberOfFriends,
      int friendRequestId, String newFriendContent) {
    var newFriend = User.fromJson(jsonDecode(newFriendContent));
    addFriend(newFriend);
  }

  @override
  void dispose() {
    _eventHub.removeNotifyAddedMemberToEventHandler(
        "EventDetailsViewModelAddedMemberToEventHandler");
    _eventHub.removeNotifyMemberQuitedEventHandler(
        "EventDetailsViewModelMemberQuitedEventHandler");
    provider.get<ChatHub>().removeAcceptedFriendRequestHandler(
        "EventDetailsViewModelCreatedNewConversationWithFriendHandler");
    _googleMapController?.dispose();
    super.dispose();
  }
}
