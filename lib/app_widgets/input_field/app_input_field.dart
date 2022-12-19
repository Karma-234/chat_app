import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    required this.counterText,
    required this.labelText,
    Key? key,
    this.validator,
    this.changed,
    this.ctrl,
    this.onSaved,
  }) : super(key: key);
  final String counterText;
  final String labelText;
  final String? Function(String?)? validator;
  final Function(String)? changed;
  final TextEditingController? ctrl;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0.h,
      child: TextFormField(
        controller: ctrl,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onChanged: changed,
        onFieldSubmitted: onSaved,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0.r),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0.r),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          label: Text(
            labelText,
            style: GoogleFonts.inter(
              fontSize: 14.0,
              height: 20 / 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          counter: Text(
            counterText,
            style: GoogleFonts.inter(
              fontSize: 14.0,
              height: 20 / 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
