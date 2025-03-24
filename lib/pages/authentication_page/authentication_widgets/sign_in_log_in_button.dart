import 'package:flutter/material.dart';

class SignInLogInButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonName;

  const SignInLogInButton({super.key, this.onTap, required this.buttonName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.pink,
        padding: const EdgeInsets.all(10),
        child: Text(
          buttonName,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
