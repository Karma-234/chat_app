import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/features/chat/view/chat_view.dart';
import 'package:chat_app/features/dashboard/controller/dashboard_ctrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants.dart';

var createConvo =
    FirebaseFirestore.instance.collection(Constants.firebaseConvoCollection);

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final searchUser =
      FirebaseFirestore.instance.collection(Constants.firebaseUsersCollection);

  RxList users = [].obs;
  var ctrl = Get.put(DashCtrl());
  final UserModel user = UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.h),
          child: TextFormField(
            onChanged: (value) async {
              try {
                Loader.show(context);
                var result = await searchUser
                    .where('email',
                        isNotEqualTo: ctrl.email.value, isEqualTo: value)
                    .get();
                if (result.docs.isEmpty) {
                  users.value = [];
                  Loader.hide();
                  return;
                }

                for (var user in result.docs) {
                  users.add(user.data());
                }
                Loader.hide();
              } catch (e) {
                Loader.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString(),
                    ),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              enabled: true,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              fillColor: Colors.grey[200],
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (users.isEmpty) {
          return Center(
            child: Text(
              'User not found',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 26.0.sp,
              ),
            ),
          );
        }
        return ListView.separated(
          itemBuilder: (c, i) => ListTile(
            title: Text(
              '${users[i]['firstname'].toString().capitalizeFirst} '
              '${users[i]['lastname'].toString().capitalizeFirst}',
              style: GoogleFonts.inter(color: Colors.black),
            ),
            subtitle: Obx(
              () => Text(
                users[i]['email'],
                style: GoogleFonts.inter(color: Colors.black),
              ),
            ),
            onTap: () async {
              ctrl.sefriend(users[i]['email']);

              await createConvo
                  .doc('${ctrl.email.value}' '_' '${ctrl.friendMail.value}')
                  .get()
                  .then((value1) async {
                if (value1.exists) {
                  ctrl.setDoc(
                      '${ctrl.email.value}' '_' '${ctrl.friendMail.value}');
                  Get.to(ChatView());
                } else {
                  await createConvo
                      .doc('${ctrl.friendMail.value}' '_' '${ctrl.email.value}')
                      .get()
                      .then((value2) async {
                    if (value2.exists) {
                      ctrl.setDoc(
                          '${ctrl.friendMail.value}' '_' '${ctrl.email.value}');
                      Get.to(ChatView());
                    } else {
                      await createConvo
                          .doc('${ctrl.email.value}'
                              '_'
                              '${ctrl.friendMail.value}')
                          .set({'messages': []}).then((value) {
                        ctrl.setDoc('${ctrl.email.value}'
                            '_'
                            '${ctrl.friendMail.value}');
                        Get.to(ChatView());
                      });
                    }
                  });
                }
              });
            },
          ),
          separatorBuilder: (c, i) => const Divider(),
          itemCount: users.length,
        );
      }),
    );
  }
}
