import 'dart:convert';

import 'package:chat_app/core/models/payloads/chat_payload.dart';
import 'package:chat_app/core/models/payloads/signup_payload.dart';

class UserModel {
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? passcode;
  final List? chats;

  UserModel({
    this.firstname,
    this.lastname,
    this.email,
    this.passcode,
    this.chats,
  });

  static UserModel fromJson(Map map) {
    return UserModel(
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      passcode: map['passcode'],
      chats: map['chats'],
    );
  }

  static UserModel fromPayload(SignupPayload payload) {
    return UserModel(
      firstname: payload.firstname,
      lastname: payload.lastname,
      email: payload.email,
      passcode: payload.passcode,
      chats: [payload.chats],
    );
  }

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'chats': chats,
        'passcode': base64Encode(passcode!.codeUnits),
      };
}
