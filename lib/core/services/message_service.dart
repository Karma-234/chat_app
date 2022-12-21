import 'package:chat_app/core/constants.dart';
import 'package:chat_app/features/dashboard/controller/dashboard_ctrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart';

class MessageService {
  var messaging = FirebaseMessaging.instance;

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Authrised');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Provisional auth');
    } else {
      print('Not granted');
    }
  }

  getToken(DashCtrl ctrl) async {
    await FirebaseMessaging.instance.getToken().then((token) {
      ctrl.setToken(token!);
    });
  }

  signUpsaveToken(DashCtrl dashCtrl) async {
    await FirebaseFirestore.instance
        .collection(Constants.firebaseTokenCollection)
        .doc(dashCtrl.email.value)
        .set(
      {'token': dashCtrl.token.value},
    );
  }

  loginSaveToken(DashCtrl dashCtrl) async {
    await FirebaseFirestore.instance
        .collection(Constants.firebaseTokenCollection)
        .doc(dashCtrl.email.value)
        .get()
        .then((value) async {
      if (value.exists) {
        await FirebaseFirestore.instance
            .collection(Constants.firebaseTokenCollection)
            .doc(dashCtrl.email.value)
            .update(
          {'token': dashCtrl.token.value},
        );
      } else {
        await FirebaseFirestore.instance
            .collection(Constants.firebaseTokenCollection)
            .doc(dashCtrl.email.value)
            .set(
          {'token': dashCtrl.token.value},
        );
      }
    });
  }
}
