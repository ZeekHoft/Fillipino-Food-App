import 'package:flutter/material.dart';

class DisplayRecipe extends StatelessWidget {
  final String recipe_name, recipe_ingredients, recipe_process, recipe_image;

  DisplayRecipe(
      {super.key,
      required this.recipe_name,
      required this.recipe_ingredients,
      required this.recipe_process,
      required this.recipe_image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Recipe name: ${recipe_name}"),
          Text("Recipe ingredients: ${recipe_ingredients}"),
          Text("Recipe process: ${recipe_process}"),
          Image.network(recipe_image),
        ],
      ),
    );
  }
}
