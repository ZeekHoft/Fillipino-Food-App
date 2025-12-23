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
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4)
      ],
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

class ColoredCheckbox extends StatefulWidget {
  const ColoredCheckbox({super.key, required this.title, this.icon});

  final String title;
  final Icon? icon;

  @override
  State<ColoredCheckbox> createState() => _ColoredCheckboxState();
}

class _ColoredCheckboxState extends State<ColoredCheckbox> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _value,
      secondary: widget.icon,
      title: Text(widget.title),
      onChanged: (value) {
        setState(() {
          _value = value!;
        });
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(4),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      tileColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}
