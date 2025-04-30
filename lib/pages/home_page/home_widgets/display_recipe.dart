import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flilipino_food_app/themes/color_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final provider = Provider.of<FavoriteProvider>(context);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    provider.toggleFavorite(recipeName);
                  },
                  icon: provider.isExist(recipeName)
                      ? const Icon(
                          Icons.bookmark,
                          color: AppColors.yellowTheme,
                        )
                      : const Icon(Icons.bookmark_add_outlined)),
            ],
          ),
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
