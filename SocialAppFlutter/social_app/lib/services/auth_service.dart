import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path/path.dart';
import 'package:social_app/services/auth/add_device_id_request.dart';
import 'package:social_app/services/auth/add_device_id_response.dart';
import 'package:social_app/services/auth/change_password_request.dart';
import 'package:social_app/services/auth/change_password_response.dart';
import 'package:social_app/services/auth/generate_password_reset_code_request.dart';
import 'package:social_app/services/auth/generate_password_reset_code_response.dart';
import 'package:social_app/services/auth/get_logged_in_profile_info_request.dart';
import 'package:social_app/services/auth/get_logged_in_profile_info_response.dart';
import 'package:social_app/services/auth/get_user_profile_request.dart';
import 'package:social_app/services/auth/get_user_profile_response.dart';
import 'package:social_app/services/auth/google_sign_in_request.dart';
import 'package:social_app/services/auth/login_request.dart';
import 'package:social_app/services/auth/login_response.dart';
import 'package:social_app/services/auth/register_request.dart';
import 'package:social_app/services/auth/register_response.dart';
import 'package:social_app/services/auth/remove_device_id_request.dart';
import 'package:social_app/services/auth/remove_device_id_response.dart';
import 'package:social_app/services/auth/reset_password_request.dart';
import 'package:social_app/services/auth/reset_password_response.dart';
import 'package:social_app/services/auth/upload_profile_image_response.dart';
import 'package:social_app/services/iauth_service.dart';
import 'package:social_app/services/profile_service.dart';
import 'package:social_app/utilities/api_utility/api_manager.dart';
import 'package:http/http.dart' as http;
import 'package:social_app/utilities/compress_utility/image_compress_service.dart';

import '../utilities/service_locator/locator.dart';

class AuthService implements IAuthService {
  final httpClient = http.Client();

  @override
  Future<LoginResponse?> logIn(String username, String password) async {
    var request = LoginRequest(username, password);

    var url = Uri.parse(
        "${ApiManager.authServiceBaseUrl}${ApiManager.authenticateUser}");
    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()));

    var loginResponse = LoginResponse.fromJson(jsonDecode(response.body));

    if (loginResponse.statusCode == 200) {
      return loginResponse;
    }

    return null;
  }

  @override
  Future<RegisterResponse?> register(String username, String email,
      String lastname, String firstname, String password) async {
    var request =
        RegisterRequest(username, email, lastname, firstname, password);

    var url =
        Uri.parse('${ApiManager.authServiceBaseUrl}${ApiManager.registerUser}');

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()));

    var registerResponse = RegisterResponse.fromJson(jsonDecode(response.body));

    if (registerResponse.statusCode == 200) {
      return registerResponse;
    }

    return null;
  }

  @override
  Future<GetUserProfileResponse?> getUserProfileResponse(
      int currentUserId, int userProfileId) async {
    var request = GetUserProfileRequest(currentUserId, userProfileId);

    var url = Uri.parse(
        '${ApiManager.authServiceBaseUrl}${ApiManager.getUserProfile}');

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Connection': 'Keep-Alive',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var getUserProfileResponse =
        GetUserProfileResponse.fromJson(jsonDecode(response.body));

    if (getUserProfileResponse.statusCode == 200) {
      return getUserProfileResponse;
    }

    return null;
  }

  @override
  Future<LoginResponse?> googleSignIn(String email, String firstname,
      String lastname, List<int>? profileUrl) async {
    var request = GoogleSignInRequest(email, firstname, lastname, profileUrl);

    var url = Uri.parse(
        "${ApiManager.authServiceBaseUrl}${ApiManager.signInWithGoogle}");
    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()));

    var loginResponse = LoginResponse.fromJson(jsonDecode(response.body));

    if (loginResponse.statusCode == 200) {
      return loginResponse;
    }

    return null;
  }

  @override
  Future<UploadProfileImageResponse?> saveProfileImage(
      File file, int userId) async {
    var result = await ImageCompressService.compressImageFromPath(
      file.absolute.path,
      150,
      150,
      60,
    );
    print(file.lengthSync());
    print(result!.length);

    final multipartFile = http.MultipartFile.fromBytes(
      'file',
      result,
      filename: basename(file.path),
    );
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "${ApiManager.authServiceBaseUrl}${ApiManager.uploadProfileImage}"),
    );

    request.headers['Authorization'] = 'Bearer ${ProfileService.accessToken}';
    request.fields['UserId'] = userId.toString();
    request.fields['ImageName'] = "profilePic";
    request.files.add(multipartFile);
    final response = await http.Response.fromStream(await request.send());

    var uploadProfileImageResponse =
        UploadProfileImageResponse.fromJson(jsonDecode(response.body));

    if (uploadProfileImageResponse.statusCode == 200) {
      return uploadProfileImageResponse;
    }

    return null;
  }

  @override
  Future<AddDeviceIdResponse?> addDeviceId(int userId, String deviceId) async {
    var request = AddDeviceIdRequest(userId, deviceId);

    var url =
        Uri.parse('${ApiManager.authServiceBaseUrl}${ApiManager.addDeviceId}');

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Connection': 'Keep-Alive',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var addDeviceIdResponse =
        AddDeviceIdResponse.fromJson(jsonDecode(response.body));

    if (addDeviceIdResponse.statusCode == 200) {
      return addDeviceIdResponse;
    }

    return null;
  }

  @override
  Future<RemoveDeviceIdResponse?> removeDeviceId(
      int userId, String deviceId) async {
    var request = RemoveDeviceIdRequest(userId, deviceId);

    var url = Uri.parse(
        '${ApiManager.authServiceBaseUrl}${ApiManager.removeDeviceId}');

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Connection': 'Keep-Alive',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var removeDeviceIdResponse =
        RemoveDeviceIdResponse.fromJson(jsonDecode(response.body));

    if (removeDeviceIdResponse.statusCode == 200) {
      return removeDeviceIdResponse;
    }

    return null;
  }

  @override
  Future getGoogleSignInProfileInfoAndUpdateProfile() async {
    // Get profile info and access token from backend auth microservice
    // if (user == null) {

    String currentGoogleLoggedInAccount =
        FirebaseAuth.instance.currentUser!.email!;

    var profileInfoResponse =
        await googleSignIn(currentGoogleLoggedInAccount, "", "", null);
    ProfileService.updateProfileInfo(profileInfoResponse!);
    ProfileService.signedInWithGoogle = true;

    FirebaseMessaging.instance.getToken().then((value) {
      addDeviceId(ProfileService.userId!, value!);
    });
    // }
  }

  @override
  Future<GetLoggedInProfileInfoResponse?> getLoggedInProfile(int userId) async {
    var request = GetLoggedInProfileInfoRequest(userId);

    var url = Uri.parse(
        '${ApiManager.authServiceBaseUrl}${ApiManager.getLoggedInProfileInfo}');

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Connection': 'Keep-Alive',
          // 'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var getLoggedInProfileInfoResponse =
        GetLoggedInProfileInfoResponse.fromJson(jsonDecode(response.body));

    if (getLoggedInProfileInfoResponse.statusCode == 200) {
      return getLoggedInProfileInfoResponse;
    }

    return null;
  }

  @override
  Future getLoggedInProfileInfoAndUpdateProfile(int userId) async {
    var profileInfoResponse =
        await provider.get<IAuthService>().getLoggedInProfile(userId);

    ProfileService.updateProfileInfo(profileInfoResponse!);
    ProfileService.signedInWithGoogle = false;

    FirebaseMessaging.instance.getToken().then((value) {
      provider.get<IAuthService>().addDeviceId(ProfileService.userId!, value!);
    });
  }

  @override
  Future<ChangePasswordResponse?> changePassword(
      int userId, String oldPassword, String newPassword) async {
    var request = ChangePasswordRequest(userId, oldPassword, newPassword);

    var url = Uri.parse(
        '${ApiManager.authServiceBaseUrl}${ApiManager.changePassword}');

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Connection': 'Keep-Alive',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var changePasswordResponse =
        ChangePasswordResponse.fromJson(jsonDecode(response.body));

    if (changePasswordResponse.statusCode == 200) {
      return changePasswordResponse;
    }

    return null;
  }

  @override
  Future<GeneratePasswordResetCodeResponse?> generatePasswordResetCode(
      String email) async {
    var request = GeneratePasswordResetCodeRequest(email);

    var url = Uri.parse(
        '${ApiManager.authServiceBaseUrl}${ApiManager.generatePasswordResetCode}');

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Connection': 'Keep-Alive'
        },
        body: jsonEncode(request.toJson()));

    var generatePasswordResetCodeResponse =
        GeneratePasswordResetCodeResponse.fromJson(jsonDecode(response.body));

    if (generatePasswordResetCodeResponse.statusCode == 200) {
      return generatePasswordResetCodeResponse;
    }

    return null;
  }

  @override
  Future<ResetPasswordResponse?> resetPassword(
      String newPassword, String resetCode) async {
    var request = ResetPasswordRequest(resetCode, newPassword);

    var url = Uri.parse(
        '${ApiManager.authServiceBaseUrl}${ApiManager.resetPassword}');

    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Connection': 'Keep-Alive'
        },
        body: jsonEncode(request.toJson()));

    var resetPasswordResponse =
        ResetPasswordResponse.fromJson(jsonDecode(response.body));

    if (resetPasswordResponse.statusCode == 200) {
      return resetPasswordResponse;
    }

    return null;
  }
}
