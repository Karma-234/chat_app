import 'dart:async';

import 'package:chat_app/core/models/payloads/login_payload.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:get/get.dart';

class Login extends GetxController {
  static Login get find => Get.find();
  final payload = LoginPayload().obs;
  final authService = FirebaseAuthService();

  setEmail(String email) {
    payload.value = payload.value.copyWith(email: email);
  }

  setpassword(String password) {
    payload.value = payload.value.copyWith(password: password);
  }

  bool get isValid => payload.value.isValid;

  FutureOr<UserModel?> login() {
    return authService.login(payload.value);
  }
}
