import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MyTextField extends StatelessWidget {

  final String hinttext;
  final IconData? myIcon;
  final TextEditingController myController;
  final String? Function(String?)? myValidator;
  final bool isObsecure;

  const MyTextField({
    super.key,
    required this.hinttext,
    required this.myController,
    this.myValidator,
    required this.myIcon, required this.isObsecure,
  });

  @override
  Widget build(Object context) {
    return SizedBox(
      height: 7.h,
      child: TextFormField(
        controller: myController,
        obscureText: isObsecure,
        enabled: true,
        enableInteractiveSelection: true,
        validator: myValidator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          hintText: hinttext,
          hintStyle: GoogleFonts.montserrat(
            color: const Color(0xff1F96CF),
            fontSize: 17.sp,
          ),
          prefixIcon: Icon(
            myIcon,
            color: const Color(0xff1F96CF),
            size: 4.h
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 15.w),
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
          errorStyle: const TextStyle(fontSize: 0 ),
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

