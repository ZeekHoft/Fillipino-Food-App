import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SocialPostDishData extends StatelessWidget {
  final int? maxLength;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final Icon? prefixIcon;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final FilteringTextInputFormatter? inputFormat;

  const SocialPostDishData(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.hintText,
      required this.prefixIcon,
      this.errorText,
      this.maxLength,
      this.keyboardType,
      this.inputFormat});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        keyboardType: keyboardType,

        inputFormatters:
            inputFormat != null ? [inputFormat!] : [], // Handle null case
        // Only numbers can be entere,
        maxLength: maxLength,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Opacity(opacity: 0.8, child: prefixIcon)
              : null,
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
