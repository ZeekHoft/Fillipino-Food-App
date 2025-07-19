import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

// Something to place, does not work yet
class ColoredPlaceholder extends StatelessWidget {
  const ColoredPlaceholder({
    super.key,
    required this.hintText,
  });
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        hintText: hintText,
        fillColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
    );
  }
}
