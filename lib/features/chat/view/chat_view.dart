import 'package:chat_app/core/constants.dart';
import 'package:chat_app/core/services/store_service.dart';
import 'package:chat_app/features/dashboard/controller/dashboard_ctrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app_widgets/input_field/message_field.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  var ctrl = Get.put(DashCtrl());

  final TextEditingController ctrl2 = TextEditingController();

  var chatServuce =
      FirebaseFirestore.instance.collection(Constants.firebaseConvoCollection);

  var usersrv =
      FirebaseFirestore.instance.collection(Constants.firebaseUsersCollection);

  final storeService = StoreService();

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
                                        fontSize: 14.0.sp, color: Colors.white),
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
              child: MessageField(
                  ctrl2: ctrl2, ctrl: ctrl, storeService: storeService),
            ),
            Gap(20.0.h),
          ],
        ),
      ),
    );
  }
}
