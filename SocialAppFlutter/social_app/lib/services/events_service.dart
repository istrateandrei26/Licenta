import 'dart:convert';

import 'package:social_app/services/events/accept_event_invitation_request.dart';
import 'package:social_app/services/events/accept_event_invitation_response.dart';
import 'package:social_app/services/events/add_google_calendar_event_request.dart';
import 'package:social_app/services/events/add_google_calendar_event_response.dart';
import 'package:social_app/services/events/check_event_to_join_request.dart';
import 'package:social_app/services/events/check_event_to_join_response.dart';
import 'package:social_app/services/events/confirm_new_location_payment_request.dart';
import 'package:social_app/services/events/confirm_new_location_payment_response.dart';
import 'package:social_app/services/events/create_event_request.dart';
import 'package:social_app/services/events/create_event_response.dart';
import 'package:social_app/services/events/create_new_location_request.dart';
import 'package:social_app/services/events/create_new_location_response.dart';
import 'package:social_app/services/events/generate_new_location_request.dart';
import 'package:social_app/services/events/generate_new_location_response.dart';
import 'package:social_app/services/events/get_attended_locations_request.dart';
import 'package:social_app/services/events/get_attended_locations_response.dart';
import 'package:social_app/services/events/get_google_calendar_event_id_request.dart';
import 'package:social_app/services/events/get_google_calendar_event_id_response.dart';
import 'package:social_app/services/events/get_new_requested_location_info_for_payment_request.dart';
import 'package:social_app/services/events/get_new_requested_location_info_for_payment_response.dart';
import 'package:social_app/services/events/remove_google_calendar_event_request.dart';
import 'package:social_app/services/events/remove_google_calendar_event_response.dart';
import 'package:social_app/services/events/retrieve_event_details_request.dart';
import 'package:social_app/services/events/retrieve_event_invites_request.dart';
import 'package:social_app/services/events/retrieve_event_invites_response.dart';
import 'package:social_app/services/events/retrieve_event_review_info_request.dart';
import 'package:social_app/services/events/retrieve_event_review_info_response.dart';
import 'package:social_app/services/events/retrieve_events_response.dart';
import 'package:social_app/services/events/retrieve_event_details_response.dart';
import 'package:social_app/services/events/retrieve_locations_by_sport_category_request.dart';
import 'package:social_app/services/events/retrieve_locations_by_sport_category_response.dart';
import 'package:social_app/services/events/review_event_as_ignored_request.dart';
import 'package:social_app/services/events/review_event_as_ignored_response.dart';
import 'package:social_app/services/ievents_service.dart';

import 'package:http/http.dart' as http;
import '../utilities/api_utility/api_manager.dart';
import 'package:social_app/services/profile_service.dart';

class EventsService implements IEventsService {
  final httpClient = http.Client();

  @override
  Future<RetrieveEventDetailsResponse?> getEventDetails(int eventId, int userId) async {
    var request = RetrieveEventDetailsRequest(eventId, userId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.getEventDetails}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var eventDetailResponse =
        RetrieveEventDetailsResponse.fromJson(jsonDecode(response.body));

    if (eventDetailResponse.statusCode == 200) {
      return eventDetailResponse;
    }

    return null;
  }

  @override
  Future<RetrieveEventsResponse?> getEvents() async {
    var url =
        Uri.parse("${ApiManager.eventServiceBaseUrl}${ApiManager.getEvents}");

    var response = await httpClient.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${ProfileService.accessToken}'
      },
    );

    var eventsResponse =
        RetrieveEventsResponse.fromJson(jsonDecode(response.body));

    if (eventsResponse.statusCode == 200) {
      return eventsResponse;
    }

    return null;
  }

  @override
  Future<RetrieveLocationsBySportCategoryResponse?> getLocationsBySportCategory(
      int userId, int categoryId) async {
    var request = RetrieveLocationsBySportCategoryRequest(categoryId, userId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.getLocationsByCategory}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var locationsResponse = RetrieveLocationsBySportCategoryResponse.fromJson(
        jsonDecode(response.body));

    if (locationsResponse.statusCode == 200) {
      return locationsResponse;
    }

    return null;
  }

  @override
  Future<CreateEventResponse?> createEvent(
      int sportCategoryId,
      int locationId,
      int creatorId,
      int requiredMembers,
      List<int> allMembers,
      DateTime startDatetime,
      double duration,
      bool createNewLocation,
      {
        double lat = 0.0,
        double long = 0.0,
        String city = '',
        String locationName = ''
      }
      ) async {
    var request = CreateEventRequest(sportCategoryId, locationId, creatorId,
        requiredMembers, startDatetime, duration, allMembers, createNewLocation, lat, long, city, locationName);

    var url =
        Uri.parse("${ApiManager.eventServiceBaseUrl}${ApiManager.createEvent}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var createEventResponse =
        CreateEventResponse.fromJson(jsonDecode(response.body));

    if (createEventResponse.statusCode == 200) {
      return createEventResponse;
    }

    return null;
  }

  @override
  Future<RetrieveEventInvitesResponse?> getEventInvites(int userId) async {
    var request = RetrieveEventInvitesRequest(userId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.getEventsInvites}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var retrieveEventsInvitesResponse =
        RetrieveEventInvitesResponse.fromJson(jsonDecode(response.body));

    if (retrieveEventsInvitesResponse.statusCode == 200) {
      return retrieveEventsInvitesResponse;
    }

    return null;
  }

  @override
  Future<RetrieveEventReviewInfoResponse?> getEventsWithoutReview(
      int userId) async {
    var request = RetrieveEventReviewInfoRequest(userId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.getEventsWithoutReview}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var retrieveEventReviewInfoResponse =
        RetrieveEventReviewInfoResponse.fromJson(jsonDecode(response.body));

    if (retrieveEventReviewInfoResponse.statusCode == 200) {
      return retrieveEventReviewInfoResponse;
    }

    return null;
  }

  @override
  Future<ReviewEventAsIgnoredResponse?> reviewEventAsIgnored(
      int eventId, int fromId) async {
    var request = ReviewEventAsIgnoredRequest(eventId, fromId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.reviewEventAsIgnored}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var reviewEventAsIgnoredResponse =
        ReviewEventAsIgnoredResponse.fromJson(jsonDecode(response.body));

    if (reviewEventAsIgnoredResponse.statusCode == 200) {
      return reviewEventAsIgnoredResponse;
    }

    return null;
  }

  @override
  Future<AcceptEventInvitationResponse?> acceptEventInvitation(
      int invitationId, int userId) async {
    var request = AcceptEventInvitationRequest(invitationId, userId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.acceptEventInvitation}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var acceptEventInvitationResponse =
        AcceptEventInvitationResponse.fromJson(jsonDecode(response.body));

    if (acceptEventInvitationResponse.statusCode == 200) {
      return acceptEventInvitationResponse;
    }

    return null;
  }

  @override
  Future<CheckEventToJoinResponse?> checkEventToJoin(
      int eventId, int userId) async {
    var request = CheckEventToJoinRequest(eventId, userId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.checkEventToJoin}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var checkEventToJoinResponse =
        CheckEventToJoinResponse.fromJson(jsonDecode(response.body));

    if (checkEventToJoinResponse.statusCode == 200) {
      return checkEventToJoinResponse;
    }

    return null;
  }

  @override
  Future<AddGoogleCalendarEventResponse?> addGoogleCalendarEvent(
      String googleCalendarEventId, int userId, int eventId) async {
    var request =
        AddGoogleCalendarEventRequest(googleCalendarEventId, userId, eventId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.addGoogleCalendarEvent}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var addGoogleCalendarEventResponse =
        AddGoogleCalendarEventResponse.fromJson(jsonDecode(response.body));

    if (addGoogleCalendarEventResponse.statusCode == 200) {
      return addGoogleCalendarEventResponse;
    }

    return null;
  }

  @override
  Future<RemoveGoogleCalendarEventResponse?> removeGoogleCalendarEvent(
      int userId, int eventId) async {
    var request = RemoveGoogleCalendarEventRequest(userId, eventId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.removeGoogleCalendarEvent}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var removeGoogleCalendarEventResponse =
        RemoveGoogleCalendarEventResponse.fromJson(jsonDecode(response.body));

    if (removeGoogleCalendarEventResponse.statusCode == 200) {
      return removeGoogleCalendarEventResponse;
    }

    return null;
  }

  @override
  Future<GetGoogleCalendarEventResponse?> getGoogleCalendarEventId(
      int userId, int eventId) async {
    var request = GetGoogleCalendarEventRequest(userId, eventId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.getGoogleCalendarEventId}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var getGoogleCalendarEventResponse =
        GetGoogleCalendarEventResponse.fromJson(jsonDecode(response.body));

    if (getGoogleCalendarEventResponse.statusCode == 200) {
      return getGoogleCalendarEventResponse;
    }

    return null;
  }

  @override
  Future<GetAttendedLocationsResponse?> getAttendedLocations(int userId) async {
    var request = GetAttendedLocationsRequest(userId);

    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.getAttendedLocations}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var getAttendedLocationsResponse =
        GetAttendedLocationsResponse.fromJson(jsonDecode(response.body));

    if (getAttendedLocationsResponse.statusCode == 200) {
      return getAttendedLocationsResponse;
    }

    return null;
  }

  @override
  Future<CreateNewLocationResponse?> createNewLocation(
      double latitude, double longitude, String city, String locationName) async {
    var request = CreateNewLocationRequest(latitude, longitude, city, locationName);
    
    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.createNewLocation}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var createNewLocationResponse =
        CreateNewLocationResponse.fromJson(jsonDecode(response.body));

    if (createNewLocationResponse.statusCode == 200) {
      return createNewLocationResponse;
    }

    return null;

  }

  @override
  Future<ConfirmNewLocationPaymentResponse?> confirmNewLocationPayment(int approvedLocationId) async {
    var request = ConfirmNewLocationPaymentRequest(approvedLocationId);
    
    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.confirmNewLocationPayment}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()));

    var confirmNewLocationPaymentResponse =
        ConfirmNewLocationPaymentResponse.fromJson(jsonDecode(response.body));

    if (confirmNewLocationPaymentResponse.statusCode == 200) {
      return confirmNewLocationPaymentResponse;
    }

    return null;
  }

  @override
  Future<GenerateNewLocationResponse?> generateNewLocationRequest(String city, String locationName, double latitude, double longitude, String ownerEmail, int sportCategoryId) async {
    var request = GenerateNewLocationRequest(city, locationName, latitude, longitude, ownerEmail, sportCategoryId);
    
    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.generateNewLocationRequest}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()));

    var generateNewLocationResponse =
        GenerateNewLocationResponse.fromJson(jsonDecode(response.body));

    if (generateNewLocationResponse.statusCode == 200) {
      return generateNewLocationResponse;
    }

    return null;
  }

  @override
  Future<GetNewRequestedLocationInfoForPaymentResponse?> getNewRequestedLocationInfoForPayment(String verificationCode) async {
    var request = GetNewRequestedLocationInfoForPaymentRequest(verificationCode);
    
    var url = Uri.parse(
        "${ApiManager.eventServiceBaseUrl}${ApiManager.getNewRequestedLocationInfoForPayment}");

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()));

    var getNewRequestedLocationInfoForPaymentResponse =
        GetNewRequestedLocationInfoForPaymentResponse.fromJson(jsonDecode(response.body));

    if (getNewRequestedLocationInfoForPaymentResponse.statusCode == 200) {
      return getNewRequestedLocationInfoForPaymentResponse;
    }

    return null;
  }
}
