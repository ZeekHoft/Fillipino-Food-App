import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final Function()? onTap;

  const SignInButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.pink,
        padding: EdgeInsets.all(10),
        child: Text("SIGN IN"),
      ),
    );
  }
}
