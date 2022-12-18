import 'package:chat_app/core/utils.dart';

class LoginPayload {
  final String? email;
  final String? password;

  LoginPayload({
    this.email,
    this.password,
  });

  LoginPayload copyWith({
    String? email,
    String? password,
  }) {
    return LoginPayload(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  bool get isValid {
    return isNotEmptyOrNull(email) && isNotEmptyOrNull(password);
  }
}
