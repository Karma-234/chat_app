import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../core/services/store_service.dart';
import '../../features/dashboard/controller/dashboard_ctrl.dart';

class MessageField extends StatelessWidget {
  const MessageField({
    Key? key,
    required this.ctrl2,
    required this.ctrl,
    required this.storeService,
  }) : super(key: key);

  final TextEditingController ctrl2;
  final DashCtrl ctrl;
  final StoreService storeService;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            controller: ctrl2,
            onChanged: (value) {
              ctrl.setmessg(value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0.r)),
            ),
          ),
        ),
        Gap(6.0.w),
        IconButton(
          onPressed: () async {
            await storeService.sendMsg(ctrl, ctrl2);
          },
          icon: const Icon(
            Icons.send,
            color: Colors.blue,
          ),
        )
      ],
    );
  }
}
