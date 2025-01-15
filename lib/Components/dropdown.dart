import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<int> options;
  final int? selectedValue;
  final ValueChanged<int?> onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40.w,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xff203540),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<int>(
            value: selectedValue,
            isExpanded: true,
            dropdownColor: const Color(0xff12232B), // Matches the app's background
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: const SizedBox(), // Removes the default underline
            onChanged: onChanged,
            items: options
                .map(
                  (value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      value.toString(),
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
