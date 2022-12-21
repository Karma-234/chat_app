import 'package:chat_app/core/services/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart';

import '../../features/dashboard/controller/dashboard_ctrl.dart';
import '../constants.dart';

class StoreService {
  var db = FirebaseFirestore.instance;
  var msgService = Get.put(MessageService());
  Future createUser(Map<String, dynamic> json) async {
    await db.collection('users').add(json).then((value) => value.get());
  }

  Future getUser() async {
    await db.collection('users').doc().get();
  }

  Future sendMsg(
    DashCtrl ctrl,
    TextEditingController ctrl2,
  ) async {
    await FirebaseFirestore.instance
        .collection(Constants.firebaseConvoCollection)
        .doc('${ctrl.email.value}'
            '_'
            '${ctrl.friendMail.value}')
        .get()
        .then((check1) async {
      if (!check1.exists) {
        await FirebaseFirestore.instance
            .collection(Constants.firebaseConvoCollection)
            .doc('${ctrl.friendMail.value}'
                '_'
                '${ctrl.email.value}')
            .get()
            .then((check2) async {
          if (check2.exists) {
            await FirebaseFirestore.instance
                .collection(Constants.firebaseConvoCollection)
                .doc('${ctrl.friendMail.value}'
                    '_'
                    '${ctrl.email.value}')
                .update({
              'messages': FieldValue.arrayUnion([
                {
                  'message': ctrl.message.value,
                  'sender': ctrl.email.value,
                  'time': DateTime.now().toUtc(),
                }
              ])
            });
            var snap = await FirebaseFirestore.instance
                .collection(Constants.firebaseTokenCollection)
                .doc(ctrl.friendMail.value)
                .get();
            var token = snap['token'];
            msgService.senPushMsg(token, ctrl.message.value, ctrl.email.value);
            ctrl2.clear();
          } else {
            await FirebaseFirestore.instance
                .collection(Constants.firebaseConvoCollection)
                .doc('${ctrl.email.value}'
                    '_'
                    '${ctrl.friendMail.value}')
                .set({'messages': []}).then((value) async {
              await FirebaseFirestore.instance
                  .collection(Constants.firebaseConvoCollection)
                  .doc('${ctrl.email.value}'
                      '_'
                      '${ctrl.friendMail.value}')
                  .update({
                'messages': FieldValue.arrayUnion([
                  {
                    'message': ctrl.message.value,
                    'sender': ctrl.email.value,
                    'time': DateTime.now().toUtc(),
                  }
                ])
              });
              var snap = await FirebaseFirestore.instance
                  .collection(Constants.firebaseTokenCollection)
                  .doc(ctrl.friendMail.value)
                  .get();
              var token = snap['token'];
              msgService.senPushMsg(
                  token, ctrl.message.value, ctrl.email.value);
              ctrl2.clear();
            });
          }
        });
      } else {
        await FirebaseFirestore.instance
            .collection(Constants.firebaseConvoCollection)
            .doc('${ctrl.email.value}'
                '_'
                '${ctrl.friendMail.value}')
            .update({
          'messages': FieldValue.arrayUnion([
            {
              'message': ctrl.message.value,
              'sender': ctrl.email.value,
              'time': DateTime.now().toUtc(),
            }
          ])
        });
        var snap = await FirebaseFirestore.instance
            .collection(Constants.firebaseTokenCollection)
            .doc(ctrl.friendMail.value)
            .get();
        var token = snap['token'];
        msgService.senPushMsg(token, ctrl.message.value, ctrl.email.value);
        ctrl2.clear();
      }
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection(Constants.firebaseUsersCollection)
          .doc(ctrl.email.value)
          .update({
        'chats': FieldValue.arrayUnion([ctrl.friendMail.value])
      });
      await FirebaseFirestore.instance
          .collection(Constants.firebaseUsersCollection)
          .doc(ctrl.friendMail.value)
          .update({
        'chats': FieldValue.arrayUnion([ctrl.email.value])
      });
    });
  }
}
