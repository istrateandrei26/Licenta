import 'package:social_app/services/events/accept_event_invitation_response.dart';
import 'package:social_app/services/events/add_google_calendar_event_response.dart';
import 'package:social_app/services/events/check_event_to_join_response.dart';
import 'package:social_app/services/events/confirm_new_location_payment_response.dart';
import 'package:social_app/services/events/create_event_response.dart';
import 'package:social_app/services/events/create_new_location_response.dart';
import 'package:social_app/services/events/generate_new_location_response.dart';
import 'package:social_app/services/events/get_attended_locations_response.dart';
import 'package:social_app/services/events/get_google_calendar_event_id_response.dart';
import 'package:social_app/services/events/get_new_requested_location_info_for_payment_response.dart';
import 'package:social_app/services/events/remove_google_calendar_event_response.dart';
import 'package:social_app/services/events/retrieve_event_details_response.dart';
import 'package:social_app/services/events/retrieve_event_invites_response.dart';
import 'package:social_app/services/events/retrieve_event_review_info_response.dart';
import 'package:social_app/services/events/retrieve_events_response.dart';
import 'package:social_app/services/events/retrieve_locations_by_sport_category_response.dart';
import 'package:social_app/services/events/review_event_as_ignored_response.dart';

abstract class IEventsService {
  Future<RetrieveEventsResponse?> getEvents();
  Future<RetrieveEventDetailsResponse?> getEventDetails(
      int eventId, int userId);
  Future<RetrieveLocationsBySportCategoryResponse?> getLocationsBySportCategory(int userId,
      int categoryId);
  Future<CreateEventResponse?> createEvent(
      int sportCategoryId,
      int locationId,
      int creatorId,
      int requiredMembers,
      List<int> allMembers,
      DateTime startDatetime,
      double duration,
      bool createNewLocation,
      {double lat = 0.0,
      double long = 0.0,
      String city = '',
      String locationName = ''});
  Future<RetrieveEventInvitesResponse?> getEventInvites(int userId);
  Future<RetrieveEventReviewInfoResponse?> getEventsWithoutReview(int userId);
  Future<ReviewEventAsIgnoredResponse?> reviewEventAsIgnored(
      int eventId, int fromId);
  Future<AcceptEventInvitationResponse?> acceptEventInvitation(
      int invitationId, int userId);
  Future<CheckEventToJoinResponse?> checkEventToJoin(int eventId, int userId);
  Future<AddGoogleCalendarEventResponse?> addGoogleCalendarEvent(
      String googleCalendarEventId, int userId, int eventId);
  Future<RemoveGoogleCalendarEventResponse?> removeGoogleCalendarEvent(
      int userId, int eventId);
  Future<GetGoogleCalendarEventResponse?> getGoogleCalendarEventId(
      int userId, int eventId);

  Future<GetAttendedLocationsResponse?> getAttendedLocations(int userId);
  Future<CreateNewLocationResponse?> createNewLocation(
      double latitude, double longitude, String city, String locationName);

  Future<GenerateNewLocationResponse?> generateNewLocationRequest(
      String city,
      String locationName,
      double latitude,
      double longitude,
      String ownerEmail,
      int sportCategoryId);

  Future<ConfirmNewLocationPaymentResponse?> confirmNewLocationPayment(
      int approvedLocationId);

  Future<GetNewRequestedLocationInfoForPaymentResponse?>
      getNewRequestedLocationInfoForPayment(String verificationCode);
}
