import 'package:flutter/material.dart';

class SocialPostDishData extends StatelessWidget {
  final dynamic controller;
  final dynamic labeltext;
  final dynamic hintext;
  final dynamic prefixicon;
  final dynamic border;
  final String? errorText;

  const SocialPostDishData(
      {super.key,
      required this.controller,
      required this.labeltext,
      required this.hintext,
      required this.prefixicon,
      required this.border,
      this.errorText});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              labelText: labeltext, prefixIcon: prefixicon, border: border),
        ),
      ),
    );
  }
}
