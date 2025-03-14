import 'package:flilipino_food_app/themse/color_themes.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class AddImage extends StatefulWidget {
  const AddImage({
    super.key,
    required this.onTap,
    required this.height,
    required this.width,
  });

  final VoidCallback onTap;
  final double height;
  final double width;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool hovered = false;
  bool tappedDown = false;

  Color get buttonColor {
    var state = (hovered, tappedDown);
    return switch (state) {
      // tapped down state
      (_, true) => AppColors.yellowTheme,
      // hovered
      (true, _) => AppColors.yellowTheme,
      // base color
      (_, _) => AppColors.yellowTheme,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          hovered = false;
        });
      },
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            tappedDown = true;
          });
        },
        onTapUp: (details) {
          setState(() {
            tappedDown = false;
          });
          widget.onTap();
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Container(
              decoration: BoxDecoration(
                color: buttonColor,
              ),
              child: const Center(
                child: Icon(
                  Symbols.add_photo_alternate_rounded,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
