import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SocialPostDishData extends StatelessWidget {
  final dynamic controller;
  final dynamic labeltext;
  final dynamic hintext;
  final dynamic prefixicon;
  final dynamic border;
  final String? errorText;
  final int? maxlength;
  final dynamic keyboardtype;
  final FilteringTextInputFormatter? inputformat;

  const SocialPostDishData(
      {super.key,
      required this.controller,
      required this.labeltext,
      required this.hintext,
      required this.prefixicon,
      required this.border,
      this.errorText,
      this.maxlength,
      this.keyboardtype,
      this.inputformat});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          keyboardType: keyboardtype,

          inputFormatters:
              inputformat != null ? [inputformat!] : [], // Handle null case
          // Only numbers can be entere,
          maxLength: maxlength,
          controller: controller,
          decoration: InputDecoration(
              labelText: labeltext, prefixIcon: prefixicon, border: border),
        ),
      ),
    );
  }
}
