import 'package:flutter/cupertino.dart';
import 'package:social_app/services/auth/generate_password_reset_code_response.dart';
import 'package:social_app/services/auth/reset_password_response.dart';
import 'package:social_app/services/iauth_service.dart';
import 'package:social_app/utilities/service_locator/locator.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController resetCodeController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  bool _resetCodeSending = false;
  bool _resetPasswordProcessing = false;
  bool _isValidEmail = true;
  bool _isValidPassword = true;
  bool _isValidConfirmPassword = true;

  String get email => emailController.text;
  String get resetCode => resetCodeController.text;
  String get newPassword => newPasswordController.text;
  String get confirmNewPassword => confirmNewPasswordController.text;
  bool get resetCodeSending => _resetCodeSending;
  bool get resetPasswordProcessing => _resetPasswordProcessing;
  bool get isValidEmail => _isValidEmail;
  bool get isValidPassword => _isValidPassword;
  bool get isValidConfirmPassword => _isValidConfirmPassword;

  setIsValidEmail(bool value) async {
    _isValidEmail = value;
    notifyListeners();
  }

  setIsValidPassword(bool value) async {
    _isValidPassword = value;
    notifyListeners();
  }

  setIsValidConfirmPassword(bool value) async {
    _isValidConfirmPassword = value;
    notifyListeners();
  }

  setResetCodeSending(bool resetCodeSending) async {
    _resetCodeSending = resetCodeSending;
    notifyListeners();
  }

  setResetPasswordProcessing(bool resetPasswordProcessing) async {
    _resetPasswordProcessing = resetPasswordProcessing;
    notifyListeners();
  }

  Future<GeneratePasswordResetCodeResponse?> generateResetCode() async {
    // await Future.delayed(const Duration(seconds: 3));

    var response =
        await provider.get<IAuthService>().generatePasswordResetCode(email);

    return response;
  }

  Future<ResetPasswordResponse?> resetPassword() async {
    // await Future.delayed(const Duration(seconds: 3));

    var response = await provider
        .get<IAuthService>()
        .resetPassword(newPassword, resetCode);

    return response;
  }
}
