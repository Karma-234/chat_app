import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RedirectButton extends StatelessWidget {
  const RedirectButton(
      {Key? key, this.pretext = '', this.linktext = '', this.onPressed})
      : super(key: key);
  final String pretext;
  final String linktext;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          pretext,
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 24 / 14,
            color: Colors.black,
          ),
        ),
        MaterialButton(
          onPressed: onPressed,
          child: Text(
            linktext,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 24 / 14,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
