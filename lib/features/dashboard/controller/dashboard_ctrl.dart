import 'dart:async';

import 'package:chat_app/core/models/payloads/chat_payload.dart';
import 'package:chat_app/core/models/payloads/login_payload.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashCtrl extends GetxController {
  static DashCtrl get find => Get.find();
  late RxString userSearch;
  late Rx<DateTime> time;
  RxString email = ''.obs;
  RxString message = ''.obs;
  RxString friendMail = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString doc = ''.obs;
  RxString token = ''.obs;
  List chats = [].obs;
  final appService = FirebaseAuthService();
  var payload = ChatPayload().obs;

  setmail(String mail) {
    email.value = mail;
  }

  setToken(String tkn) {
    token.value = tkn;
  }

  setmessg(String msg) {
    message.value = msg;
  }

  setfirst(String fn) {
    firstName.value = fn;
  }

  setlast(String ln) {
    lastName.value = ln;
  }

  setdate(DateTime dateTime) {
    payload.value = payload.value.copyWith(createdAt: dateTime);
  }

  sefriend(String friend) {
    friendMail.value = friend;
  }

  setDoc(String docName) {
    doc.value = docName;
  }

  set messgae(String text) {
    message.value = text;
  }

  bool get isValid {
    return email.value.isEmail && email.value.isNotEmpty;
  }

  FutureOr<UserModel?> searchUser(String query) async {
    return appService.searchUsers(query);
  }
}
