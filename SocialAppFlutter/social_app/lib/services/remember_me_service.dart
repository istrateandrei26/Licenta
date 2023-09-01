import '../utilities/service_locator/locator.dart';
import 'iauth_service.dart';
import 'local_database/sqlite_database_service.dart';

class RememberMeService {
  static Future initializeLoggedInUserIfAny() async {
    var loggedUsers = await SqliteDatabaseHelper.instance.getLoggedUsers();
  if (loggedUsers.isNotEmpty) {
    print(
        'UserId: ${loggedUsers.first.userId}, SignedWithGoogle: ${loggedUsers.first.signedWithGoogle}');
    var rememberedUser = loggedUsers.first;

    if (rememberedUser.signedWithGoogle == 1) {
      await provider
          .get<IAuthService>()
          .getGoogleSignInProfileInfoAndUpdateProfile();
    } else {
      // Complete ProfileService for user when it is not signed with google
      await provider
          .get<IAuthService>()
          .getLoggedInProfileInfoAndUpdateProfile(rememberedUser.userId);
    }
  }
  }
}