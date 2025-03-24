import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final Function()? onTap;

  const ForgotPassword({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Forgot password"),
      ),
    );
  }
}
