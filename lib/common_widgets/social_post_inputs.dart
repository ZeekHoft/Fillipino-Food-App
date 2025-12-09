import 'package:flutter/material.dart';

class SocialPostInputs extends StatelessWidget {
  final int? maxLines;
  final String labelText;
  final String errorText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const SocialPostInputs(
      {super.key,
      required this.controller,
      required this.keyboardType,
      required this.labelText,
      required this.errorText,
      this.maxLines = 3,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            bottom: 4.0,
          ),
          child: Text(labelText, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
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
        ),
      ],
    );
  }
}
