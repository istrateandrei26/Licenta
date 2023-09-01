import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Models/calendar_event.dart';
import 'package:social_app/Models/event.dart';
import 'package:social_app/Models/event_invitation.dart';
import 'package:social_app/services/events/event_hub/event_hub.dart';
import 'package:social_app/services/events/retrieve_event_invites_response.dart';
import 'package:social_app/services/google/igoogle_calendar_service.dart';
import 'package:social_app/services/ievents_service.dart';
import 'package:social_app/services/local_calendar_service.dart';
import 'package:social_app/services/local_notification_service.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/user_settings.dart/user_settings.dart';
import 'package:social_app/utilities/service_locator/locator.dart';

import '../Models/user.dart';
import '../services/google/google_sign_in_service.dart';

const String GOOGLE_EVENT_OVERLAPS = "GOOGLE_OVERLAPS";
const String SERVICE_EVENT_OVERLAPS = "SERVICE_OVERLAPS";
const String SERVICE_EVENT_EXPIRED = "SERVICE_EXPIRED";
const String SERVICE_EVENT_FULL = "SERVICE_FULL";
const String SUCCESSFULLY_JOINED = "JOINED";

class EventInvitesViewModel extends ChangeNotifier {
  List<EventInvitation> _eventInvites = [];
  bool _processing = false;

  List<EventInvitation> get eventInvites => _eventInvites;
  bool get processing => _processing;

  final EventHub _eventHub = provider.get<EventHub>();

  EventInvitesViewModel() {
    _eventHub.addInvitedUserToEventHandler(
        "EventInvitesViewModelInvitedUserToEventHandler",
        (content) => onInvitedUserToEvent(content));

    _eventHub.addNotifyMemberJoinedEventHandler(
        "EventInvitesViewModelAddedMemberJoinedEventHandler",
        (newMemberInfo, eventId) =>
            onReceivedMemberJoinedEventNotification(newMemberInfo, eventId));
  }

  addInvitation(EventInvitation invitation) {
    var invitationExistsAccepted = _eventInvites.any(
        (element) => element.id == invitation.id && element.accepted == true);

    if (invitationExistsAccepted) {
      _eventInvites
          .firstWhere((element) => element.id == invitation.id)
          .accepted = false;
    } else {
      _eventInvites.add(invitation);
    }
    notifyListeners();
  }

  onInvitedUserToEvent(String content) {
    var invitation = EventInvitation.fromJson(jsonDecode(content));
    addInvitation(invitation);
  }

  onReceivedMemberJoinedEventNotification(String newMemberInfo, int eventId) {
    var newMember = User.fromJson(jsonDecode(newMemberInfo));

    var invitationExists = _eventInvites.any((element) =>
        element.event.id == eventId && element.toUser.id == newMember.id);

    if (invitationExists) {
      _eventInvites
          .firstWhere((element) =>
              element.event.id == eventId && element.toUser.id == newMember.id)
          .accepted = true;
      notifyListeners();
    }
  }

  setProcessing(bool processing) {
    _processing = processing;
    notifyListeners();
  }

  setEventInvitationAcceptanceProcessing(int invitationId, bool processing) {
    var invitation =
        _eventInvites.firstWhere(((element) => element.id == invitationId));

    invitation.processing = processing;
    notifyListeners();
  }

  setEventInvites(List<EventInvitation> eventInvites) {
    _eventInvites = eventInvites;
    notifyListeners();
  }

  acceptEventInvitationUI(int invitationId) {
    _eventInvites
        .firstWhere(((element) => element.id == invitationId))
        .accepted = true;
    notifyListeners();
  }

  removeEventInvitation(int invitationId) {
    _eventInvites.removeWhere((element) => element.id == invitationId);
    notifyListeners();
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

  Future<String?> acceptEventInvitation(
      BuildContext context, EventInvitation invitation) async {
    setEventInvitationAcceptanceProcessing(invitation.id, true);

    var eventToBeAdded = invitation.event;
    var startTime = eventToBeAdded.startDateTime;
    var endTime = eventToBeAdded.startDateTime
        .add(Duration(minutes: eventToBeAdded.duration.toInt()));

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
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return GOOGLE_EVENT_OVERLAPS;
      } else {
        //  try to accept event invitation in database:
        var response = (await provider
            .get<IEventsService>()
            .acceptEventInvitation(invitation.id, ProfileService.userId!))!;
        // check in response if event was expired or busy:
        if (response.expired) {
          setEventInvitationAcceptanceProcessing(invitation.id, false);
          removeEventInvitation(invitation.id);
          return SERVICE_EVENT_EXPIRED;
        }

        if (response.full) {
          setEventInvitationAcceptanceProcessing(invitation.id, false);
          return SERVICE_EVENT_FULL;
        }

        if (response.busy) {
          setEventInvitationAcceptanceProcessing(invitation.id, false);
          return SERVICE_EVENT_OVERLAPS;
        }
        // the event has been successfully inserted into Events Service, so now we can insert it into Google Calendar
        // ignore: use_build_context_synchronously
        await addGoogleCalendarEvent(
            context, eventToBeAdded, authHeader.accessToken!);

        await _eventHub.addMemberToEvent(
            ProfileService.userId!, invitation.event.id);
        acceptEventInvitationUI(invitation.id);
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return SUCCESSFULLY_JOINED;
      }
    } else if (ProfileService.signedInWithGoogle &&
        !UserSettings.googleCalendarEnabled &&
        UserSettings.localCalendarEnabled) {
      //  try to accept event invitation in database:
      var response = (await provider
          .get<IEventsService>()
          .acceptEventInvitation(invitation.id, ProfileService.userId!))!;
      // check in response if event was expired or busy:
      if (response.expired) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        removeEventInvitation(invitation.id);
        return SERVICE_EVENT_EXPIRED;
      }

      if (response.full) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return SERVICE_EVENT_FULL;
      }

      if (response.busy) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return SERVICE_EVENT_OVERLAPS;
      }

      await _eventHub.addMemberToEvent(
          ProfileService.userId!, invitation.event.id);

      acceptEventInvitationUI(invitation.id);
      setEventInvitationAcceptanceProcessing(invitation.id, false);
      // the event has been successfully inserted into Events Service, so now we can insert it into Local Calendar
      LocalCalendarService().addEventToLocalCalendar(
          eventToBeAdded.location.locationName.trim(),
          eventToBeAdded.sportCategory.name.trim(),
          startTime,
          eventToBeAdded.duration);
      return SUCCESSFULLY_JOINED;
    } else if (ProfileService.signedInWithGoogle &&
        !UserSettings.googleCalendarEnabled &&
        !UserSettings.localCalendarEnabled) {
      //  try to accept event invitation in database:
      var response = (await provider
          .get<IEventsService>()
          .acceptEventInvitation(invitation.id, ProfileService.userId!))!;
      // check in response if event was expired or busy:
      if (response.expired) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        removeEventInvitation(invitation.id);
        return SERVICE_EVENT_EXPIRED;
      }

      if (response.full) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return SERVICE_EVENT_FULL;
      }

      if (response.busy) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return SERVICE_EVENT_OVERLAPS;
      }

      await _eventHub.addMemberToEvent(
          ProfileService.userId!, invitation.event.id);
      // the event has been successfully inserted into Events Service
      acceptEventInvitationUI(invitation.id);
      setEventInvitationAcceptanceProcessing(invitation.id, false);
      return SUCCESSFULLY_JOINED;
    }

    if (!ProfileService.signedInWithGoogle &&
        UserSettings.localCalendarEnabled) {
      //  try to accept event invitation in database:
      var response = (await provider
          .get<IEventsService>()
          .acceptEventInvitation(invitation.id, ProfileService.userId!))!;
      // check in response if event was expired or busy:
      if (response.expired) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        removeEventInvitation(invitation.id);
        return SERVICE_EVENT_EXPIRED;
      }

      if (response.full) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return SERVICE_EVENT_FULL;
      }

      if (response.busy) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return SERVICE_EVENT_OVERLAPS;
      }

      //  schedule notification, if user has not google calendar enabled:
      LocalNotificationService().scheduleNotification(
          title:
              "${eventToBeAdded.sportCategory.name.trim()}, ${eventToBeAdded.location.locationName.trim()}",
          body: "Don't forget to be there !",
          scheduledNotificationDateTime:
              startTime.subtract(const Duration(minutes: 60)));

      await _eventHub.addMemberToEvent(
          ProfileService.userId!, invitation.event.id);
      acceptEventInvitationUI(invitation.id);
      setEventInvitationAcceptanceProcessing(invitation.id, false);
      // the event has been successfully inserted into Events Service, so now we can insert it into Local Calendar
      LocalCalendarService().addEventToLocalCalendar(
          eventToBeAdded.location.locationName.trim(),
          eventToBeAdded.sportCategory.name.trim(),
          startTime,
          eventToBeAdded.duration);

      return SUCCESSFULLY_JOINED;
    } else if (!ProfileService.signedInWithGoogle &&
        !UserSettings.localCalendarEnabled) {
      //  try to accept event invitation in database:
      var response = (await provider
          .get<IEventsService>()
          .acceptEventInvitation(invitation.id, ProfileService.userId!))!;

      // check in response if event was expired or busy:
      if (response.expired) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        removeEventInvitation(invitation.id);
        return SERVICE_EVENT_EXPIRED;
      }

      if (response.full) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return SERVICE_EVENT_FULL;
      }

      if (response.busy) {
        setEventInvitationAcceptanceProcessing(invitation.id, false);
        return SERVICE_EVENT_OVERLAPS;
      }

      //  schedule notification, if user has not google calendar enabled:
      LocalNotificationService().scheduleNotification(
          title:
              "${eventToBeAdded.sportCategory.name.trim()}, ${eventToBeAdded.location.locationName.trim()}",
          body: "Don't forget to be there !",
          scheduledNotificationDateTime:
              startTime.subtract(const Duration(minutes: 60)));

      await _eventHub.addMemberToEvent(
          ProfileService.userId!, invitation.event.id);

      acceptEventInvitationUI(invitation.id);
      setEventInvitationAcceptanceProcessing(invitation.id, false);
      return SUCCESSFULLY_JOINED;
    }

    setEventInvitationAcceptanceProcessing(invitation.id, false);

    return null;
  }

  Future<RetrieveEventInvitesResponse?> initialize() async {
    setProcessing(true);

    await _eventHub.connect();

    var response = await provider
        .get<IEventsService>()
        .getEventInvites(ProfileService.userId!); //change id!!!

    setEventInvites(response!.invites);
    setProcessing(false);

    return response;
  }

  @override
  void dispose() {
    _eventHub.removeInvitedUserToEventHandler(
        "EventInvitesViewModelInvitedUserToEventHandler");

    _eventHub.removeNotifyMemberJoinedEventHandler(
        "EventInvitesViewModelAddedMemberJoinedEventHandler");
    super.dispose();
  }
}
