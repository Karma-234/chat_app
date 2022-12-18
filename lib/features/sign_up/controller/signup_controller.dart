import 'dart:async';

import 'package:chat_app/core/models/payloads/signup_payload.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:get/get.dart';

class SignUpCtrl extends GetxController {
  static SignUpCtrl get find => Get.find();
  final payload = SignupPayload().obs;
  final authService = FirebaseAuthService();
  late User user;
  @override
  void onInit() {
    super.onInit();
    // User(
    //     email: userEmail.value,
    //     passcode: passcode.value,
    //     firstname: firstname.value,
    //     lastname: lastname.value);
  }

  setEmail(String email) {
    payload.value = payload.value.copyWith(email: email);
  }

  setFirstName(String firstName) {
    payload.value = payload.value.copyWith(firstname: firstName);
  }

  setLastname(String lastName) {
    payload.value = payload.value.copyWith(lastname: lastName);
  }

  setpassword(String password) {
    payload.value = payload.value.copyWith(password: password);
  }

  setPasscode(String code) {
    payload.value = payload.value.copyWith(passcode: code);
  }

  bool get validate => payload.value.isValid;

  FutureOr<UserModel?> register() {
    return authService.signUp(payload.value);
  }
}
