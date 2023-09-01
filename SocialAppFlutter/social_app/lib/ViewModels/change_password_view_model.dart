import 'package:flutter/cupertino.dart';
import 'package:social_app/services/auth/change_password_response.dart';
import 'package:social_app/services/iauth_service.dart';
import 'package:social_app/services/profile_service.dart';

import '../utilities/service_locator/locator.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  bool _processing = false;
  bool _isValidConfirmPassword = true;
  bool _passwordsMatch = true;

  String get oldPassword => oldPasswordController.text;
  String get newPassword => newPasswordController.text;
  String get confirmNewPassword => confirmNewPasswordController.text;
  bool get processing => _processing;
  bool get isValidConfirmPassword => _isValidConfirmPassword;
  bool get passwordsMatch => _passwordsMatch;

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  setIsValidConfirmPassword(bool value) async {
    _isValidConfirmPassword = value;
    notifyListeners();
  }

  setPasswordsMatch(bool value) async {
    _passwordsMatch = true;
    notifyListeners();
  }

  Future<ChangePasswordResponse?> changePassword() async {
    // await Future.delayed(const Duration(seconds: 10));

    var response = await provider
        .get<IAuthService>()
        .changePassword(ProfileService.userId!, oldPassword, newPassword);

    return response;
  }
}
