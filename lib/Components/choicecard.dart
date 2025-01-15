// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class HomeChoiceCard extends StatefulWidget {
  final void Function()? onTap;
  final IconData icon;
  final String title;
  bool isSelected;

  HomeChoiceCard({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
    required this.isSelected,
  });

  @override
  State<HomeChoiceCard> createState() => _HomeChoiceCardState();
}

class _HomeChoiceCardState extends State<HomeChoiceCard> {

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
          height: 26.w,
          width: 26.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.isSelected
                ? const Color(0xff20A9EB).withOpacity(0.07)
                : Colors.white12.withOpacity(0.05),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 10.w,
                color: widget.isSelected
                  ?const Color(0xff20A9EB)
                  :Colors.white,
              ),
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: widget.isSelected
                  ?const Color(0xff20A9EB)
                  :Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
