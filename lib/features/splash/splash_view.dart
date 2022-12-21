import 'package:chat_app/core/services/message_service.dart';
import 'package:chat_app/features/dashboard/view/dashview1.dart';
import 'package:chat_app/features/login/view/loginview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sign_up/view/signup_view1.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});
  final MessageService messageService = Get.put(MessageService());

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && !currentUser.isAnonymous) {
        Get.offAll(() => LoginView());
      } else {
        Get.offAll(() => SignUpView1());
      }
      messageService.requestPermission();
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
