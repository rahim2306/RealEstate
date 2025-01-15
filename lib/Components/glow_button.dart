import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class MyGlowingButton extends StatefulWidget {

  final String text;
  final Function onTap;
  final bool hasEmail;
  

  const MyGlowingButton({super.key, required this.text, required this.onTap, required this.hasEmail});

  @override
  State<MyGlowingButton> createState() => _MyGlowingButtonState();
}

class _MyGlowingButtonState extends State<MyGlowingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 40.w),
      height: 6.5.h,  
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff20A9EB).withOpacity(0.8),
            blurRadius: 15,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff20A9EB), 
              Color(0xff047FBA)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onTap(),
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(widget.hasEmail)
                    Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                      size: 18.sp*1.4,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      widget.text,
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}