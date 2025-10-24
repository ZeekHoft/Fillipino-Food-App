import 'package:flutter/material.dart';

class SocialPostInputs extends StatelessWidget {
  final dynamic controller;
  final dynamic keyboardType;
  final dynamic maxLines;
  final String labelText;
  final String errorText;
  final dynamic border;

  const SocialPostInputs(
      {super.key,
      required this.controller,
      required this.keyboardType,
      required this.maxLines,
      required this.labelText,
      required this.errorText,
      required this.border});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: labelText,
            border: border,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
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
    );
  }
}
