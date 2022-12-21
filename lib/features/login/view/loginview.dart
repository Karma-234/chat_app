import 'package:chat_app/core/services/message_service.dart';
import 'package:chat_app/features/dashboard/controller/dashboard_ctrl.dart';
import 'package:chat_app/features/dashboard/view/dashview1.dart';
import 'package:chat_app/features/login/controller/login_ctrl.dart';
import 'package:chat_app/features/sign_up/view/signup_view1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../app_widgets/button/app_button.dart';
import '../../../app_widgets/button/redirect_button.dart';
import '../../../app_widgets/input_field/app_input_field.dart';
import '../../../core/constants.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final ctrl = Get.put(Login(), permanent: true);
  final ctrl2 = Get.put(DashCtrl(), permanent: true);
  final msgService = Get.put(MessageService());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0).w,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(23.0.h),
                AppInputField(
                  ctrl: TextEditingController(text: 'jojo@jaja.com'),
                  labelText: 'Email',
                  counterText: 'Email',
                  changed: (p0) => ctrl.setEmail(p0),
                ),
                AppInputField(
                  ctrl: TextEditingController(text: '12345678'),
                  labelText: 'Password',
                  counterText: ' Password',
                  changed: (p0) => ctrl.setpassword(p0),
                ),
                const Spacer(),
                RedirectButton(
                  pretext: 'New account ?',
                  linktext: 'Sign up',
                  onPressed: () => Get.to(() => SignUpView1()),
                ),
                Gap(20.0.h),
                Obx(() {
                  return AppButton(
                    label: 'Login',
                    onPresses: ctrl.isValid
                        ? () async {
                            try {
                              Loader.show(
                                context,
                                progressIndicator:
                                    const CircularProgressIndicator(),
                              );
                              final user = await ctrl.login();
                              if (user != null) {
                                Get.put(
                                  user,
                                );
                                ctrl2.setmail(ctrl.payload.value.email!);
                                await FirebaseFirestore.instance
                                    .collection(
                                        Constants.firebaseUsersCollection)
                                    .where('email',
                                        isEqualTo: ctrl2.email.value)
                                    .get()
                                    .then((value) {
                                  for (var user in value.docs) {
                                    ctrl2.setfirst(user.data()['firstname']);
                                    ctrl2.setlast(user.data()['lastname']);
                                    ctrl2.chats.add(user.data()['chats']);
                                  }
                                });
                                msgService.loginSaveToken(ctrl2);
                              }
                              Loader.hide();

                              Get.offAll(
                                () => DashView1(),
                              );
                            } catch (e) {
                              Loader.hide();

                              debugPrint(e.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                  );
                }),
                Gap(30.0.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
