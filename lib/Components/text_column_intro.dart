import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class MyTextColumn extends StatelessWidget {

  final String firstText;
  final String secondText;
  final String thirdText;

  const MyTextColumn({super.key, required this.firstText, required this.secondText, required this.thirdText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            firstText,
            style: GoogleFonts.montserrat(
              fontSize: 20.50.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ), 
          ),
          Text(
            secondText,
            style: GoogleFonts.montserrat(
              fontSize: 20.50.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ), 
          ),
          SizedBox(height: 1.h),
          Text(
            thirdText,
            style: GoogleFonts.montserrat(
              fontSize: 20.50.sp*.56,
              fontWeight: FontWeight.normal,
              color: Colors.white70,
            ), 
          ),
        ],
      ),
    );
  }
}