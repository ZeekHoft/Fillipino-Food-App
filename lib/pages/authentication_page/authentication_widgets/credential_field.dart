import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CredentialField extends StatelessWidget {
  final bool isNumber;
  final String hintText;
  final bool obscureText;
  final String? labelText;
  final FormFieldValidator? validator;
  final Function(String)? onChangeFunc;
  final TextEditingController controller;

  const CredentialField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    this.validator,
    this.labelText,
    this.onChangeFunc,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        hintText: hintText,
        labelText: labelText,
      ),
      validator: validator,
      controller: controller,
      onChanged: onChangeFunc,
      obscureText: obscureText,
      keyboardType: isNumber ? TextInputType.number : null,
      inputFormatters: isNumber ? [LengthLimitingTextInputFormatter(4)] : null,
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }
}
