import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flilipino_food_app/themes/color_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final recipeName = provider.recipeName;
    return Scaffold(
      appBar: AppBar(
        title: const Text("favorite area"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipeName
                      .map((name) => Text(
                            name,
                            style: const TextStyle(fontSize: 24),
                          ))
                      .toList(),
                ),

                // const SizedBox(height: 16),
                // const Text("Ingredients", style: TextStyle(fontSize: 24)),
                // Text(recipeIngredients),
                // const SizedBox(height: 16),
                // const Text("Process", style: TextStyle(fontSize: 24)),
                // Text(recipeProcess),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
