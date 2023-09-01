import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth/login_response.dart';
import '../services/iauth_service.dart';
import '../utilities/service_locator/locator.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _processing = false;

  String get username => usernameController.text;
  String get password => passwordController.text;
  bool get processing => _processing;

  setProcessing(bool processing) async {
    _processing = processing;
    notifyListeners();
  }

  Future<LoginResponse?> logIn() async {
    setProcessing(true);

    var response = await provider.get<IAuthService>().logIn(username, password);

    setProcessing(false);

    return response;
  }
}
