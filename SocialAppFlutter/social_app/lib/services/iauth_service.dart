import 'dart:io';

import 'package:social_app/services/auth/add_device_id_response.dart';
import 'package:social_app/services/auth/change_password_response.dart';
import 'package:social_app/services/auth/generate_password_reset_code_response.dart';
import 'package:social_app/services/auth/get_logged_in_profile_info_response.dart';
import 'package:social_app/services/auth/get_user_profile_response.dart';
import 'package:social_app/services/auth/register_response.dart';
import 'package:social_app/services/auth/remove_device_id_response.dart';
import 'package:social_app/services/auth/reset_password_response.dart';
import 'package:social_app/services/auth/upload_profile_image_response.dart';

import 'auth/login_response.dart';

abstract class IAuthService {
  Future<LoginResponse?> logIn(String username, String password);
  Future<RegisterResponse?> register(String username, String email,
      String lastname, String firstname, String password);
  Future<GetUserProfileResponse?> getUserProfileResponse(
      int currentUserId, int userProfileId);
  Future<LoginResponse?> googleSignIn(
      String email, String firstname, String lastname, List<int>? profileUrl);
  Future<GetLoggedInProfileInfoResponse?> getLoggedInProfile(int userId);
  Future<UploadProfileImageResponse?> saveProfileImage(File file, int userId);
  Future<AddDeviceIdResponse?> addDeviceId(int userId, String deviceId);
  Future<RemoveDeviceIdResponse?> removeDeviceId(int userId, String deviceId);

  Future<ChangePasswordResponse?> changePassword(
      int userId, String oldPassword, String newPassword);
  Future getGoogleSignInProfileInfoAndUpdateProfile();
  Future getLoggedInProfileInfoAndUpdateProfile(int userId);
  Future<GeneratePasswordResetCodeResponse?> generatePasswordResetCode(
      String email);
  Future<ResetPasswordResponse?> resetPassword(
      String newPassword, String resetCode);
}
