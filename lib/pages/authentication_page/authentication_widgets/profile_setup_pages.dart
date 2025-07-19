import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/credential_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tell us about yourself",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        Text("Your height"),
        const SizedBox(height: 4),
        ColoredInputNumber(
          hintText: "Enter your height",
          suffixText: "cm",
        ),
        const SizedBox(height: 8),
        Text("Your weight"),
        const SizedBox(height: 4),
        ColoredInputNumber(
          hintText: "Enter your weight",
          suffixText: "kg",
        ),
        CredentialField(
          controller: TextEditingController(),
          hintText: "Your gender",
        ),
        CredentialField(
          controller: TextEditingController(),
          hintText: "Your birthday",
        ),
      ],
    );
  }
}

class ColoredInputNumber extends StatelessWidget {
  const ColoredInputNumber({
    super.key,
    this.controller,
    this.suffixText,
    required this.hintText,
  });

  final String hintText;
  final String? suffixText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        hintText: hintText,
        suffixText: suffixText,
        fillColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(4)],
    );
  }
}
