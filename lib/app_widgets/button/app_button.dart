import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  const AppButton({Key? key, this.onPresses, this.label = ''})
      : super(key: key);

  final Function()? onPresses;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPresses,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            13.0.r,
          ),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14.0,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
