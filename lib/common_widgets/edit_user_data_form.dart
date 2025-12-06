import 'package:flutter/material.dart';

class EditUserDataForm extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const EditUserDataForm(
      {super.key, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller, decoration: InputDecoration(hintText: hint));
  }
}
