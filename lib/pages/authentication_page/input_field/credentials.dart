import 'package:flilipino_food_app/themse/color_themes.dart';
import 'package:flutter/material.dart';

class Credentials extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const Credentials(
      {super.key,
      this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueTheme),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.redTheme),
            ),
            focusColor: Colors.green,
            filled: true,
            hintText: hintText),
      ),
    );
  }
}
