import 'package:social_app/services/auth/login_response.dart';

class ProfileService {
  static String accessToken = '';
  static String refreshToken = '';
  static String username = '';
  static int? userId;
  static String email = '';
  static String firstname = '';
  static String lastname = '';
  static List<int>? profileImage = [];
  static bool signedInWithGoogle = false;
  static bool eventsReviewAlreadyCalledOnce = false;

  static void updateProfileInfo(LoginResponse response) {
    accessToken = response.accessToken;
    refreshToken = response.refreshToken;
    username = response.username;
    userId = response.id;
    email = response.email;
    firstname = response.firstname;
    lastname = response.lastname;
    profileImage = response.profileImage;
  }

  static void clearProfileInfo() {
    accessToken = '';
    refreshToken = '';
    username = '';
    userId = null;
    email = '';
    firstname = '';
    profileImage?.clear();
    signedInWithGoogle = false;
  }

  static void updateToken() {
    // todo
  }
}
