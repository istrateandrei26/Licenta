class ApiManager {
  // static const String authServiceBaseUrl = "https://172.20.10.4:7179";
  // static const String chatServiceBaseUrl = "https://172.20.10.4:7013";
  // static const String eventServiceBaseUrl = "https://172.20.10.4:7011";

  static const String authServiceBaseUrl = "https://52.157.198.88:30007";
  static const String chatServiceBaseUrl = "https://52.157.198.88:30008";
  static const String eventServiceBaseUrl = "https://52.157.198.88:30009";

  static const String authenticateUser = "/api/Auth/login";
  static const String getUserProfile = "/api/Auth/getUserProfile";
  static const String registerUser = "/api/Auth/register";
  static const String refreshToken = "/api/Auth/refreshToken";
  static const String signInWithGoogle = "/api/Auth/googleSignIn";
  static const String uploadProfileImage = "/api/Auth/uploadProfileImage";
  static const String addDeviceId = "/api/Auth/addDeviceId";
  static const String removeDeviceId = "/api/Auth/removeDeviceId";
  static const String getLoggedInProfileInfo =
      "/api/Auth/getLoggedInProfileInfo";
  static const String changePassword = "/api/Auth/changePassword";
  static const String generatePasswordResetCode =
      "/api/Auth/generatePasswordResetCode";
  static const String resetPassword = "/api/Auth/resetPassword";

  static const String getChatList = "/api/Chat/getChatList";
  static const String getMessages = "/api/Chat/getMessages";
  static const String getFriendRequests = "/api/Chat/getFriendRequests";
  static const String getFriends = "/api/Chat/getUserFriends";
  static const String getCommonStuff = "/api/Chat/getCommonStuff";

  static const String getEvents = "/api/Event/getEvents";
  static const String getEventDetails = "/api/Event/getEventDetails";
  static const String getLocationsByCategory =
      "/api/Event/getLocationsBySportCategory";
  static const String createEvent = "/api/Event/createEvent";
  static const String getEventsInvites = "/api/Event/getEventInvites";
  static const String getEventsWithoutReview =
      "/api/Event/getEventsWithoutReview";
  static const String reviewEventAsIgnored = "/api/Event/reviewEventAsIgnored";
  static const String acceptEventInvitation =
      "/api/Event/acceptEventInvitation";
  static const String checkEventToJoin = "/api/Event/checkEventToJoin";
  static const String addGoogleCalendarEvent =
      "/api/Event/addGoogleCalendarEvent";
  static const String removeGoogleCalendarEvent =
      "/api/Event/removeGoogleCalendarEvent";
  static const String getGoogleCalendarEventId =
      "/api/Event/getGoogleCalendarEventId";
  static const String getAttendedLocations = "/api/Event/getAttendedLocations";
  static const String createNewLocation = "/api/Event/createNewLocation";
  static const String generateNewLocationRequest =
      "/api/Event/generateNewLocationRequest";
  static const String confirmNewLocationPayment =
      "/api/Event/confirmNewLocationPayment";
  static const String getNewRequestedLocationInfoForPayment =
      "/api/Event/getNewRequestedLocationInfoForPayment";
}
