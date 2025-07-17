import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flilipino_food_app/themes/color_themes.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayRecipe extends StatefulWidget {
  final String recipeName, recipeIngredients, recipeProcess, recipeImage;
  final int recipeCalories;
  final String documentId; // Add documentId here

  const DisplayRecipe(
      {super.key,
      required this.recipeName,
      required this.recipeIngredients,
      required this.recipeProcess,
      required this.recipeImage,
      required this.recipeCalories,
      required this.documentId // Require documentId
      });

  @override
  State<DisplayRecipe> createState() => _DisplayRecipeState();
}

class _DisplayRecipeState extends State<DisplayRecipe> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final userEmail = context.watch<ProfileDataStoring>();

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          SizedBox(
              height: 300,
              child: Image.network(
                widget.recipeImage,
                fit: BoxFit.fitWidth,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    provider.toggleFavorite(
                      widget.documentId, // Pass the document ID
                      widget.recipeName,
                      widget.recipeImage,
                      widget.recipeCalories,
                      widget.recipeIngredients,
                      widget.recipeProcess,
                    );
                  },
                  icon: provider.isExist(
                          widget.documentId) // Check existence with document ID
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
                  widget.recipeName,
                  style: const TextStyle(fontSize: 48, height: 0.8),
                ),
                const SizedBox(height: 16),
                const Text("Ingredients", style: TextStyle(fontSize: 24)),
                Text(widget.recipeIngredients),
                const SizedBox(height: 16),
                const Text("Process", style: TextStyle(fontSize: 24)),
                Text(widget.recipeProcess),
                const Text("calories", style: TextStyle(fontSize: 24)),
                Text(widget.recipeCalories.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
