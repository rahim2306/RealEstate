import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MyWilayasTextField extends StatefulWidget {
  final String hinttext;
  final IconData? myIcon;
  final TextEditingController myController;
  final String? Function(String?)? myValidator;
  final bool isObsecure;
  final List<String> suggestions;

  const MyWilayasTextField({
    super.key,
    required this.hinttext,
    required this.myController,
    this.myValidator,
    required this.myIcon,
    required this.isObsecure,
    required this.suggestions,
  });

  @override
  State<MyWilayasTextField> createState() => _MyWilayasTextFieldState();
}

class _MyWilayasTextFieldState extends State<MyWilayasTextField> {
  List<String> filteredSuggestions = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    widget.myController.addListener(() {
      final query = widget.myController.text.toLowerCase();
      setState(() {
        if (query.isEmpty) {
          filteredSuggestions.clear();
        } else {
          filteredSuggestions = widget.suggestions
              .where((s) => s.toLowerCase().contains(query))
              .toList();
        }
      });
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          filteredSuggestions.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 7.h,
          child: TextFormField(
            controller: widget.myController,
            focusNode: _focusNode,
            obscureText: widget.isObsecure,
            enabled: true,
            enableInteractiveSelection: true,
            validator: widget.myValidator,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              hintText: widget.hinttext,
              hintStyle: GoogleFonts.montserrat(
                color: const Color(0xff1F96CF),
                fontSize: 17.sp,
              ),
              prefixIcon: Icon(
                widget.myIcon,
                color: const Color(0xff1F96CF),
                size: 4.h,
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 15.w),
              filled: true,
              fillColor: const Color(0xff132934),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                gapPadding: 0,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                    width: 2.0, style: BorderStyle.solid, color: Colors.red),
              ),
              errorStyle: const TextStyle(fontSize: 0.01),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
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
        ),
        if (filteredSuggestions.isNotEmpty)
          Container(
            constraints: BoxConstraints(maxHeight: 30.h),
            decoration: BoxDecoration(
              color: const Color(0xff132934),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView(
              shrinkWrap: true,
              children: filteredSuggestions.map((suggestion) {
                return ListTile(
                  title: Text(
                    suggestion,
                    style: GoogleFonts.montserrat(
                      color: const Color(0xff1F96CF),
                      fontSize: 14.sp,
                    ),
                  ),
                  onTap: () {
                    widget.myController.text = suggestion;
                    setState(() {
                      filteredSuggestions.clear();
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    widget.myController.removeListener(() {});
    _focusNode.dispose();
    super.dispose();
  }
}
