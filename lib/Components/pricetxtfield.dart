import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PriceTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final String? Function(String?) myValidator;

  const PriceTextField({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.myValidator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 7.h,
      child: TextFormField(
        controller: controller,
        validator: myValidator,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 3.w ,vertical: 15),
          suffixText: ' DA',
          suffixStyle: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          hintText: hinttext,
          hintStyle: GoogleFonts.montserrat(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff1F96CF),
          ),
          filled: true,
          fillColor: const Color(0xff132934),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none
            ),
            gapPadding: 0
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2.0,
              style: BorderStyle.solid,
              color: Colors.red
            )
          ),
          errorStyle: const TextStyle(fontSize: 0.01),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:  const BorderSide(
              color: Colors.red,
              style: BorderStyle.solid,
            ),
          ),
        ), 
        style: GoogleFonts.montserrat(
          color: const Color(0xff1F96CF),
          fontWeight: FontWeight.w500,
          fontSize: 17.sp,
        ),
      ),
    );
  }
}
