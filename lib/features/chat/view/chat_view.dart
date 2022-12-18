import 'package:chat_app/core/constants.dart';
import 'package:chat_app/features/dashboard/controller/dashboard_ctrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatView extends StatefulWidget {
  ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  var ctrl = Get.put(DashCtrl());

  final TextEditingController ctrl2 = TextEditingController();

  var chatServuce =
      FirebaseFirestore.instance.collection(Constants.firebaseConvoCollection);
  var usersrv =
      FirebaseFirestore.instance.collection(Constants.firebaseUsersCollection);

  RxString? doc;

  void getData() async {
    await chatServuce
        .doc('${ctrl.email.value}'
            '_'
            '${ctrl.friendMail.value}')
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          doc?.value = '${ctrl.email.value}'
              '_'
              '${ctrl.friendMail.value}';
        });
      } else {
        chatServuce
            .doc('${ctrl.friendMail.value}'
                '_'
                '${ctrl.email.value}')
            .get()
            .then((value) async {
          if (value.exists) {
            setState(() {
              doc?.value = '${ctrl.friendMail.value}'
                  '_'
                  '${ctrl.email.value}';
            });
          } else {
            await chatServuce
                .doc('${ctrl.email.value}'
                    '_'
                    '${ctrl.friendMail.value}')
                .set({'messages': []}).then((value) {
              setState(() {
                doc?.value = '${ctrl.email.value}'
                    '_'
                    '${ctrl.friendMail.value}';
              });
            });
          }
        });
      }
    });
    chatServuce;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ctrl.friendMail.value),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0.w,
                  vertical: 12.0.h,
                ),
                color: Colors.white,
                child: Obx(
                  () => StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(Constants.firebaseConvoCollection)
                        .doc(ctrl.doc.value)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            'You have no messages yet. Send the first  text below! ',
                            style: GoogleFonts.inter(
                                fontSize: 14.0.sp, color: Colors.black),
                          ),
                        );
                      }
                      var output = snapshot.data!;
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: output['messages'][index]
                                          ['sender'] ==
                                      ctrl.email.value
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0).r,
                                  decoration: BoxDecoration(
                                      color: output['messages'][index]
                                                  ['sender'] ==
                                              ctrl.email.value
                                          ? Colors.blue
                                          : Colors.green[700]),
                                  child: Text(
                                    output['messages'][index]['message']
                                        .toString(),
                                    style: GoogleFonts.inder(
                                        fontSize: 18.0.sp, color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Gap(15.0.h);
                          },
                          itemCount: output['messages'].length);
                    },
                  ),
                ),
              ),
            ),
            Gap(10.0.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0).w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: ctrl2,
                      onChanged: (value) {
                        ctrl.setmessg(value);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Gap(6.0.w),
                  IconButton(
                    onPressed: () async {
                      await chatServuce
                          .doc('${ctrl.email.value}'
                              '_'
                              '${ctrl.friendMail.value}')
                          .get()
                          .then((check1) async {
                        if (!check1.exists) {
                          await chatServuce
                              .doc('${ctrl.friendMail.value}'
                                  '_'
                                  '${ctrl.email.value}')
                              .get()
                              .then((check2) async {
                            if (check2.exists) {
                              await chatServuce
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
                            } else {
                              await chatServuce
                                  .doc('${ctrl.email.value}'
                                      '_'
                                      '${ctrl.friendMail.value}')
                                  .set({'messages': []}).then((value) async {
                                await chatServuce
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
                              });
                            }
                          });
                        } else {
                          await chatServuce
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
                        }
                      }).then((value) async {
                        ctrl2.clear();
                        getData();
                        await usersrv.doc(ctrl.email.value).update({
                          'chats':
                              FieldValue.arrayUnion([ctrl.friendMail.value])
                        });
                        await usersrv.doc(ctrl.friendMail.value).update({
                          'chats': FieldValue.arrayUnion([ctrl.email.value])
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
            Gap(20.0.h),
          ],
        ),
      ),
    );
  }
}
