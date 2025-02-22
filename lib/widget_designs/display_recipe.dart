import 'package:flutter/material.dart';

class DisplayRecipe extends StatelessWidget {
  final String recipeName, recipeIngredients, recipeProcess, recipeImage;

  const DisplayRecipe(
      {super.key,
      required this.recipeName,
      required this.recipeIngredients,
      required this.recipeProcess,
      required this.recipeImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Recipe name: $recipeName"),
          Text("Recipe ingredients: $recipeIngredients"),
          Text("Recipe process: $recipeProcess"),
          Image.network(recipeImage),
        ],
      ),
    );
  }
}
