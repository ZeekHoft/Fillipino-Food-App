import 'package:flutter/material.dart';

class SocialPostInputs extends StatelessWidget {
  final int maxLines;
  final String labelText;
  final String errorText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const SocialPostInputs({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.labelText,
    required this.errorText,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: labelText,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorText;
          }
          return null;
        },
      ),
    );
  }
}
