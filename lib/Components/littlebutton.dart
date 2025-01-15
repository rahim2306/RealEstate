import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MyLittleButton extends StatelessWidget {
  final String text;
  final Function? onTap;
  const MyLittleButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: onTap != null ?  const Color(0xff20A9EB).withOpacity(0.1) : Colors.transparent,
      highlightColor: onTap != null ?  const Color(0xff20A9EB).withOpacity(0.1) : Colors.transparent,
      hoverColor: onTap != null ?  const Color(0xff20A9EB).withOpacity(0.1) : Colors.transparent,
      onTap: () => onTap!(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xff20A9EB).withOpacity(0.07),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.7.h),
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                color: const Color(0xff20A9EB),
                fontWeight: FontWeight.w400
              ),
            ),
          ),
        ),
      ),
    );
  }
}