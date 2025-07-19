import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
