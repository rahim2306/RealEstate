// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TypeChoiceCard extends StatefulWidget {
  final void Function()? onTap;
  final String title;
  bool isSelected;

  TypeChoiceCard({
    super.key,
    this.onTap,
    required this.title,
    required this.isSelected,
  });

  @override
  State<TypeChoiceCard> createState() => _TypeChoiceCardState();
}

class _TypeChoiceCardState extends State<TypeChoiceCard> {

  void toggleSelection() {
    setState(() {
      widget.isSelected = !widget.isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          toggleSelection();
          if (widget.onTap != null) widget.onTap!();
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: const Color.fromARGB(255, 68, 102, 131).withOpacity(0.3),
        highlightColor: const Color.fromARGB(255, 68, 102, 131).withOpacity(0.1),
        child: Container(
          height: 5.h,
          width: 30.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: widget.isSelected 
              ?[
                const Color(0xff20A9EB), 
                const Color(0xff047FBA)
               ] 
              :[
                Colors.white12.withOpacity(0.05),
                Colors.white12.withOpacity(0.05)
               ]

            ),
          ),
          child: Center(
            child: Text(
              widget.title,
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
