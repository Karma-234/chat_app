import 'dart:convert';

import 'package:chat_app/core/constants.dart';
import 'package:chat_app/features/dashboard/controller/dashboard_ctrl.dart';
import 'package:chat_app/features/login/view/loginview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  initInfo() {
    var androidInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    var initialSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    FlutterLocalNotificationsPlugin().initialize(
      initialSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          try {
            try {
              if (details.payload != null && details.payload!.isNotEmpty) {}
            } catch (e) {}
          } catch (e) {}
        }
      },
    );
    FirebaseMessaging.onMessage.listen((messsage) async {
      BigTextStyleInformation textStyleInformation = BigTextStyleInformation(
        messsage.notification!.body.toString(),
        htmlFormatBigText: true,
        htmlFormatContent: true,
        contentTitle: messsage.notification!.title.toString(),
      );
      AndroidNotificationDetails androidNotiDetails =
          AndroidNotificationDetails(
        'dbfood',
        'dbfood',
        priority: Priority.max,
        playSound: true,
        importance: Importance.high,
        styleInformation: textStyleInformation,
      );
      DarwinNotificationDetails iosNotiDetails =
          const DarwinNotificationDetails();
      NotificationDetails platformSpec = NotificationDetails(
        android: androidNotiDetails,
        iOS: iosNotiDetails,
      );
      await FlutterLocalNotificationsPlugin().show(
        0,
        messsage.notification?.title,
        messsage.notification?.body,
        platformSpec,
        payload: messsage.data['body'],
      );
    });
  }

  void senPushMsg(String token, String body, String title) async {
    try {
      await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA8Kr3wNM:APA91bG7lfaOGKHM0o6nN-aXk1rqpCtptQdWdmf3kScEzJddH964uaQxRsNCu-cjSywAheVDTD349gqtLYDqAyr8PnjyArJTy-fC6JYPnoNpYXpQKbo8K-MuUQhXkJLKwTFnfl2Gr0ft'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "dbfood"
            },
            "to": token
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
