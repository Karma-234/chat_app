import 'package:chat_app/core/constants.dart';
import 'package:chat_app/features/dashboard/controller/dashboard_ctrl.dart';
import 'package:chat_app/features/dashboard/view/dashview1.dart';
import 'package:chat_app/features/login/view/loginview.dart';
import 'package:chat_app/features/sign_up/controller/signup_controller.dart';
import 'package:chat_app/core/services/store_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../app_widgets/button/app_button.dart';
import '../../../app_widgets/button/redirect_button.dart';
import '../../../app_widgets/input_field/app_input_field.dart';

class SignUpView1 extends StatelessWidget {
  SignUpView1({super.key});
  final GlobalKey<FormState> form = GlobalKey();
  final ctrl = Get.put(SignUpCtrl(), permanent: true);
  final ctrl2 = Get.put(DashCtrl(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1956FB),
              Color(0xFF3558B7),
            ],
            stops: [.28, 1],
          ),
        ),
        child: Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppInputField(
                                labelText: 'First name',
                                counterText: 'First name',
                                changed: (p0) => ctrl.setFirstName(p0),
                              ),
                            ),
                            Gap(6.0.w),
                            Expanded(
                              child: AppInputField(
                                labelText: 'Last name',
                                counterText: 'Last name',
                                changed: (p0) => ctrl.setLastname(p0),
                              ),
                            ),
                          ],
                        ),
                        AppInputField(
                          labelText: 'Email',
                          counterText: 'Email',
                          changed: (p0) => ctrl.setEmail(p0),
                        ),
                        AppInputField(
                          labelText: 'Password',
                          counterText: ' Password',
                          changed: (p0) => ctrl.setpassword(p0),
                        ),
                        Pinput(
                          length: 6,
                          onChanged: (value) {},
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onCompleted: (value) => ctrl.setPasscode(value),
                        )
                      ],
                    ),
                  ),
                  Gap(40.0.h),
                  RedirectButton(
                    pretext: 'Already have an account ? ',
                    linktext: 'Log in',
                    onPressed: () => Get.to(() => LoginView()),
                  ),
                  Gap(40.0.h),
                  Obx(
                    () {
                      return AppButton(
                        label: 'Sign up',
                        onPresses: ctrl.validate
                            ? () async {
                                try {
                                  Loader.show(
                                    context,
                                    progressIndicator:
                                        const CircularProgressIndicator(),
                                  );
                                  final user = await ctrl.register();
                                  if (user != null) {
                                    Get.put(user, permanent: true);
                                    ctrl2.setmail(ctrl.payload.value.email!);
                                    await FirebaseFirestore.instance
                                        .collection(
                                            Constants.firebaseUsersCollection)
                                        .where('email',
                                            isEqualTo: ctrl2.email.value)
                                        .get()
                                        .then((value) {
                                      for (var user in value.docs) {
                                        ctrl2
                                            .setfirst(user.data()['firstname']);
                                        ctrl2.setlast(user.data()['lastname']);
                                        ctrl2.chats.add(user.data()['chats']);
                                      }
                                    });
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
                    },
                  ),
                  Gap(24.0.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
