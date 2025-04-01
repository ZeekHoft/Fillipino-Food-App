import 'package:flilipino_food_app/pages/recipe_output.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      shrinkWrap: true,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: CircleAvatar(
            radius: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Hello, USERNAME",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 24),
        Text(
          "Recipes",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const RecipeOutput(),
      ],
    );
  }
}
