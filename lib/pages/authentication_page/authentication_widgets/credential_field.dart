import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CredentialField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool isNumber;
  final Function(String)? onChangeFunc;
  final FormFieldValidator? validator;

  const CredentialField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.onChangeFunc,
    this.validator,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // autovalidateMode: AutovalidateMode.onUnfocus,
      autovalidateMode: AutovalidateMode.always,

      onChanged: onChangeFunc,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: isNumber ? TextInputType.number : null,
      inputFormatters: isNumber ? [LengthLimitingTextInputFormatter(4)] : null,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        hintText: hintText,
      ),
    );
  }
}
