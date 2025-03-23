import 'package:flilipino_food_app/themse/color_themes.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final Function()? onTap;

  const ForgotPassword({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.balckTheme,
        padding: EdgeInsets.all(10),
        child: const Text("Forgot password"),
      ),
    );
  }
}
