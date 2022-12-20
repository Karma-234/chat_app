import 'package:chat_app/core/constants.dart';
import 'package:chat_app/core/models/message_model.dart';
import 'package:chat_app/core/models/payloads/login_payload.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/features/chat/view/chat_view.dart';
import 'package:chat_app/features/dashboard/controller/dashboard_ctrl.dart';
import 'package:chat_app/features/search/views/search_view.dart';
import 'package:chat_app/features/sign_up/controller/signup_controller.dart';
import 'package:chat_app/features/sign_up/view/signup_view1.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

var userDetails = [].obs;

class DashView1 extends StatelessWidget {
  DashView1({super.key});

  final TextEditingController ctrl = TextEditingController();
  final chatRef =
      FirebaseFirestore.instance.collection(Constants.firebaseConvoCollection);

  final service = FirebaseAuthService();

  final dash = Get.put(DashCtrl(), permanent: true);
  final ctrl2 = Get.put(SignUpCtrl(), permanent: true);
  // final service = AuthServiceImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0.h),
          child: Obx(
            () => Text(
              '${dash.firstName.value.toString().capitalizeFirst} '
              ' ${dash.lastName.value.toString().capitalize} ',
              style: GoogleFonts.inter(
                  fontSize: 14.0, color: Colors.black, height: 20 / 14),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Loader.show(context);
              await FirebaseAuthService().logout();
              Loader.hide();
              Get.offAll(SignUpView1());
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () async {
              Get.to(SearchView());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(Constants.firebaseUsersCollection)
            .doc(dash.email.value)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'You have no chats.',
                style: GoogleFonts.inter(color: Colors.black, fontSize: 14.sp),
              ),
            );
          }
          var output = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Saved Contacts',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 30.sp,
                ),
              ),
              Gap(23.0.h),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: ListView.separated(
                      itemBuilder: (c, i) {
                        return ListTile(
                          title: Text(
                            output['chats'][i] ?? '',
                            style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          onTap: () async {
                            dash.sefriend(output['chats'][i]);
                            await createConvo
                                .doc('${dash.email.value}'
                                    '_'
                                    '${dash.friendMail.value}')
                                .get()
                                .then((value1) async {
                              if (value1.exists) {
                                dash.setDoc('${dash.email.value}'
                                    '_'
                                    '${dash.friendMail.value}');
                                Get.to(ChatView());
                              } else {
                                await createConvo
                                    .doc('${dash.friendMail.value}'
                                        '_'
                                        '${dash.email.value}')
                                    .get()
                                    .then((value2) async {
                                  if (value2.exists) {
                                    dash.setDoc('${dash.friendMail.value}'
                                        '_'
                                        '${dash.email.value}');
                                  } else {
                                    await createConvo
                                        .doc('${dash.email.value}'
                                            '_'
                                            '${dash.friendMail.value}')
                                        .set({'messages': []}).then((value) {
                                      dash.setDoc('${dash.email.value}'
                                          '_'
                                          '${dash.friendMail.value}');
                                      Get.to(ChatView());
                                    });
                                  }
                                });
                              }
                            });
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: output['chats'].length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
