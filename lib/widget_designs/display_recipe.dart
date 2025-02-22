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
      body: ListView(
        children: [
          SizedBox(
              height: 300,
              child: Image.network(
                recipeImage,
                fit: BoxFit.fitWidth,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  recipeName,
                  style: const TextStyle(fontSize: 48, height: 0.8),
                ),
                const SizedBox(height: 16),
                const Text("Ingredients", style: TextStyle(fontSize: 24)),
                Text(recipeIngredients),
                const SizedBox(height: 16),
                const Text("Process", style: TextStyle(fontSize: 24)),
                Text(recipeProcess),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
