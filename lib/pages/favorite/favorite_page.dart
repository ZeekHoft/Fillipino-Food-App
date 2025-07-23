import 'package:flilipino_food_app/pages/favorite/favorite_item.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    // This will trigger the loading of favorite IDs and then fetching their details from Firestore
    Provider.of<FavoriteProvider>(context, listen: false).loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);

    // Now, these lists are populated by the loadFavorites() method after fetching from Firestore
    final recipeNames = provider.recipeName;
    final recipeImages = provider.recipeImage;
    final recipeCalories = provider.recipeCalories;
    final recipeIngredients = provider.recipeIngredients;
    final recipeProcesses = provider.recipeProcess;
    final favoriteRecipeIds = provider.favoriteRecipeIds; // Get the list of IDs

    if (favoriteRecipeIds.isEmpty) {
      return const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text("Waiting for favorites")
        ],
      ));
    } else {
      return CustomScrollView(
        slivers: [
          SliverList.list(children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Saved Recipes",
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 24)
          ]),
          SliverList.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: favoriteRecipeIds
                .length, // Use recipeNames.length as they are aligned
            itemBuilder: (context, index) {
              return FavoriteItem(
                favName: recipeNames[index],
                favIngredient: recipeIngredients[index],
                favProcess: recipeProcesses[index],
                favImage: recipeImages[index],
                favCalories: recipeCalories[index],
                documentId: favoriteRecipeIds[
                    index], // Pass the document ID to FavoriteItem
              );
            },
          )
        ],
      );
    }
  }
}
