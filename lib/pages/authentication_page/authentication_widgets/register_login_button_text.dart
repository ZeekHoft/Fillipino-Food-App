import 'package:flutter/material.dart';

class RegisterLoginButtonText extends StatelessWidget {
  final Function()? onTap;
  final String someText;
  const RegisterLoginButtonText(
      {super.key, this.onTap, required this.someText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        someText,
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
}
