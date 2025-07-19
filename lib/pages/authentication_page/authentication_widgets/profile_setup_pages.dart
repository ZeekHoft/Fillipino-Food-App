import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/colored_inputs.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          "Tell us about yourself",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text("Your height"),
        const ColoredInputNumber(
          hintText: "Enter your height",
          suffixText: "cm",
        ),
        const SizedBox(height: 8),
        const Text("Your weight"),
        const ColoredInputNumber(
          hintText: "Enter your weight",
          suffixText: "kg",
        ),
        const Text("Your gender"),
        const ColoredPlaceholder(
          hintText: "Select your gender",
        ),
        const SizedBox(height: 8),
        const Text("Your birthday"),
        const ColoredPlaceholder(
          hintText: "dd / mm / yyyy",
        ),
      ],
    );
  }
}
