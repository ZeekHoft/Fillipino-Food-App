import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditUserDataFormText extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const EditUserDataFormText(
      {super.key, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hint),
    );
  }
}

class EditUserDataFormNumbers extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const EditUserDataFormNumbers(
      {super.key, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hint),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4)
      ],
    );
  }
}
