import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/services/local_database/sqlite_database_service.dart';
import 'package:social_app/services/profile_service.dart';

import '../../utilities/service_locator/locator.dart';
import '../iauth_service.dart';

class GoogleSignInService extends ChangeNotifier {
  final googleSignIn = GoogleSignIn(scopes: [
    "https://www.googleapis.com/auth/calendar",
    "https://www.googleapis.com/auth/calendar.events"
  ]);

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future googleSimpleSignIn() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      _user = googleUser;
    } catch (e) {
      print(e.toString());
      SystemNavigator.pop();
    }
  }

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        SystemNavigator.pop();
        return;
      }

      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // Retrieve lastname and firstname
      Map<String, dynamic>? idMap = parseJwt(googleAuth.idToken);
      String firstName = "";
      String lastName = "";
      if (idMap != null) {
        firstName = idMap["given_name"];
        lastName = idMap["family_name"];
      }

      // List<int>? profileImageBytes;

      // if (googleUser.photoUrl != null) {
      //   profileImageBytes = await http
      //       .get(Uri.parse(user!.photoUrl!))
      //       .then((response) => response.bodyBytes);

      //   var profileImageBytesCompressed =
      //       await ImageCompressService.compressImageFromBytes(
      //     Uint8List.fromList(profileImageBytes!),
      //     150,
      //     150,
      //     60,
      //   );

      //   if (profileImageBytesCompressed!.length < profileImageBytes.length) {
      //     profileImageBytes = profileImageBytesCompressed;
      //   }
      // } else {
      //   profileImageBytes = null;
      // }
      // String profileUrl =
      //     googleUser.photoUrl != null ? googleUser.photoUrl! : "user_icon.png";
      // Login in our microservice :
      var googleSignInResponse = await provider
          .get<IAuthService>()
          .googleSignIn(googleUser.email, firstName, lastName, null);

      ProfileService.updateProfileInfo(googleSignInResponse!);
      ProfileService.signedInWithGoogle = true;

      await SqliteDatabaseHelper.instance
          .add(LoggedUser(userId: ProfileService.userId!, signedWithGoogle: 1));

      await FirebaseAuth.instance.signInWithCredential(credential);

      FirebaseMessaging.instance.getToken().then((value) {
        provider
            .get<IAuthService>()
            .addDeviceId(ProfileService.userId!, value!);
      });
    } catch (e) {
      print(e.toString());
      SystemNavigator.pop();
    }

    notifyListeners();
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Map<String, dynamic>? parseJwt(String? token) {
    // validate token
    if (token == null) return null;
    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    // retrieve token payload
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    // convert to Map
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }
}
