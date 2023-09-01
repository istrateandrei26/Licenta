import 'package:flutter/widgets.dart';
import 'package:social_app/services/auth/register_response.dart';

import '../services/iauth_service.dart';
import '../utilities/service_locator/locator.dart';

class RegisterViewModel extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  bool _processing = false;

  bool _isValidUsername = true;
  bool _isValidEmail = true;
  bool _isValidFirstname = true;
  bool _isValidLastname = true;
  bool _isValidPassword = true;
  bool _isValidConfirmPassword = true;

  String get username => usernameController.text;
  String get email => emailController.text;
  String get firstname => firstnameController.text;
  String get lastname => lastnameController.text;
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;

  bool get processing => _processing;
  bool get isValidUsername => _isValidUsername;
  bool get isValidEmail => _isValidEmail;
  bool get isValidFirstname => _isValidFirstname;
  bool get isValidLastname => _isValidLastname;
  bool get isValidPassword => _isValidPassword;
  bool get isValidConfirmPassword => _isValidConfirmPassword;

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  setIsValidUsername(bool value) async {
    _isValidUsername = value;
    notifyListeners();
  }

  setIsValidEmail(bool value) async {
    _isValidEmail = value;
    notifyListeners();
  }

  setIsValidFirstname(bool value) async {
    _isValidFirstname = value;
    notifyListeners();
  }

  setIsValidLastname(bool value) async {
    _isValidLastname = value;
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

  Future<RegisterResponse?> register() async {
    setProcessing(true);

    var response = await provider
        .get<IAuthService>()
        .register(username, email, lastname, firstname, password);

    setProcessing(false);

    return response;
  }
}
