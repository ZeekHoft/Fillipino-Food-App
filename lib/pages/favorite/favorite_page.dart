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
    // Need to add delay it slightly to ensure context is ready

    Provider.of<FavoriteProvider>(context, listen: false)
        .loadFavorites(); // this calls out the function from fav_prov file,
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final recipeName = provider.recipeName;
    final recipeImage = provider.recipeImage;
    final recipeCalories = provider.recipeCalories;
    final recipeIngredients = provider.recipeIngredients;
    final recipeProcess = provider.recipeProcess;

    if (recipeName.isEmpty) {
      return const Center(child: Text("No favorites yet"));
    } else {
      return CustomScrollView(
        slivers: [
          SliverList.list(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Saved Recipes",
                  style: Theme.of(context).textTheme.displaySmall),
            ),
            const SizedBox(height: 24)
          ]),
          SliverList.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: recipeName.length,
            itemBuilder: (context, index) {
              return FavoriteItem(
                favName: recipeName[index],
                favIngredient: recipeIngredients[index],
                favProcess: recipeProcess[index],
                favImage: recipeImage[index],
                favCalories: recipeCalories[index],
              );
            },
          )
        ],
      );
    }
  }
}
