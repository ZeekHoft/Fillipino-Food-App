import 'package:flilipino_food_app/pages/favorite/favorite_item.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_social_item.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_social_provider.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
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
    Provider.of<FavoriteProvider>(context, listen: false).loadRecipeFavorites();
    Provider.of<FavoriteSocialProvider>(context, listen: false)
        .loadSocialFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final recipProvider = Provider.of<FavoriteProvider>(context);
    final socialProvider = Provider.of<FavoriteSocialProvider>(context);

    // Now, these lists are populated by the loadFavorites() method after fetching from Firestore
    final recipeNames = recipProvider.recipeNames;
    final favoriteRecipeIds = recipProvider.recipeFavoriteId;

    final recipeImages = recipProvider.recipeImages;
    final recipeCalories = recipProvider.recipeCalories;
    final recipeIngredients = recipProvider.recipeIngredients;
    final recipeProcesses = recipProvider.recipeProcess;
    // Get the list of IDs

    final socialPostFavorites = socialProvider.favoritePost;

    // This part of the code avoids having to encounter index errors by
    // asynchronus checking recipe and social favorites
    final bool isLoadingRecipes = favoriteRecipeIds.isNotEmpty &&
        (recipeNames.length != favoriteRecipeIds.length);
    final bool allFavoritesEmpty =
        favoriteRecipeIds.isEmpty && socialPostFavorites.isEmpty;

    if (isLoadingRecipes || allFavoritesEmpty) {
      return const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DappliProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text("Waiting for favorites")
        ],
      ));
    } else {
      return Column(
        children: [
          Text("Saved Recipes", style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                  itemCount: favoriteRecipeIds.length,
                  itemBuilder: (context, index) {
                    return FavoriteItem(
                      favName: recipeNames[index],
                      favIngredient: recipeIngredients[index],
                      favProcess: recipeProcesses[index],
                      favImage: recipeImages[index],
                      favCalories: recipeCalories[index],
                      documentId: favoriteRecipeIds[index],
                      // Pass the document ID to FavoriteItem
                    );
                  }),
            ),
          ),
          const Divider(height: 1),
          Text("Saved Social Posts",
              style: Theme.of(context).textTheme.titleLarge),
          // FavoriteSocialItem()
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FavoriteSocialItem(
                    screenState: true,
                    post: {}, //passes an emtpy array of value, need fix later
                  )))
        ],
      );

      // CustomScrollView(
      //   slivers: [
      //     SliverList.list(children: [
      //       const SizedBox(height: 24),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 16),
      //         child: Text("Saved Recipes",
      //             style: Theme.of(context).textTheme.titleLarge),
      //       ),
      //       const SizedBox(height: 24)
      //     ]),
      //     SliverList.separated(
      //       separatorBuilder: (context, index) => const Divider(),
      //       itemCount: favoriteRecipeIds
      //           .length, // Use recipeNames.length as they are aligned
      //       itemBuilder: (context, index) {
      //         return FavoriteItem(
      //           favName: recipeNames[index],
      //           favIngredient: recipeIngredients[index],
      //           favProcess: recipeProcesses[index],
      //           favImage: recipeImages[index],
      //           favCalories: recipeCalories[index],
      //           documentId: favoriteRecipeIds[index],
      //           // Pass the document ID to FavoriteItem
      //         );
      //       },
      //     )
      //   ],
      // );
    }
  }
}
