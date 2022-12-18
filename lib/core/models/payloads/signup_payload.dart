import 'package:chat_app/core/utils.dart';

class SignupPayload {
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? password;
  final String? passcode;
  final List? chats;

  SignupPayload({
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.passcode,
    this.chats,
  });

  SignupPayload copyWith(
      {String? firstname,
      String? lastname,
      String? email,
      String? password,
      String? passcode,
      List? chats}) {
    return SignupPayload(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      passcode: passcode ?? this.passcode,
      password: password ?? this.password,
      chats: chats ?? this.chats,
    );
  }

  bool get isValid {
    return isNotEmptyOrNull(firstname) &&
        isNotEmptyOrNull(lastname) &&
        isNotEmptyOrNull(email) &&
        isNotEmptyOrNull(password) &&
        isNotEmptyOrNull(passcode);
  }
}
