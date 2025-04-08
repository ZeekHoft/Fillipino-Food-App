import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CredentialField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Function(String)? onChangeFunc;

  const CredentialField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.onChangeFunc});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChangeFunc,
      controller: controller,
      obscureText: obscureText,
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

class CredentialFieldNumbers extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Function(String)? onChangeFunc;

  const CredentialFieldNumbers(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.onChangeFunc});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChangeFunc,
      controller: controller,
      obscureText: obscureText,
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(4)],
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
