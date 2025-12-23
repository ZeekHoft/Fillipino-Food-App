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

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // This will trigger the loading of favorite IDs and then fetching their details from Firestore
    Provider.of<FavoriteProvider>(context, listen: false).loadRecipeFavorites();
    Provider.of<FavoriteSocialProvider>(context, listen: false)
        .loadSocialFavorites();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipProvider = Provider.of<FavoriteProvider>(context);
    final socialProvider = Provider.of<FavoriteSocialProvider>(context);

    // Now, these lists are populated by the loadFavorites() method after fetching from Firestore
    final favoriteRecipeIds = recipProvider.recipeFavoriteId;

    final recipeImages = recipProvider.recipeImages;
    final recipeCalories = recipProvider.recipeCalories;
    final List<dynamic> recipeIngredients = recipProvider.recipeIngredients;
    final List<dynamic> recipeProcesses = recipProvider.recipeProcess;
    // Get the list of IDs

    final socialPostFavorites = socialProvider.favoritePost;

    // This part of the code avoids having to encounter index errors by
    // asynchronous checking recipe and social favorites
    final bool allFavoritesEmpty =
        favoriteRecipeIds.isEmpty && socialPostFavorites.isEmpty;

    if (recipProvider.isLoading || socialProvider.isLoading) {
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
        ),
      );
    } else if (allFavoritesEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No saved recipes or posts yet!",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Bookmark recipes to see them here.",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          TabBar(
            controller: _tabController,
            // indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "Recipes"),
              Tab(text: "Posts"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FavoriteRecipesList(recipeProvider: recipProvider),
                FavoritePostsList(socialProvider: socialProvider),
              ],
            ),
          ),
        ],
      );
    }
  }
}

class FavoriteRecipesList extends StatelessWidget {
  const FavoriteRecipesList({super.key, required this.recipeProvider});

  final FavoriteProvider recipeProvider;

  @override
  Widget build(BuildContext context) {
    final recipeNames = recipeProvider.recipeNames;
    final recipeImages = recipeProvider.recipeImages;
    final recipeCalories = recipeProvider.recipeCalories;
    final recipeProcesses = recipeProvider.recipeProcess;
    final favoriteRecipeIds = recipeProvider.recipeFavoriteId;
    final recipeIngredients = recipeProvider.recipeIngredients;

    return ListView.builder(
      itemCount: favoriteRecipeIds.length,
      itemBuilder: (context, index) {
        return FavoriteItem(
          favName: recipeNames[index],
          favIngredient: recipeIngredients[index],
          favProcess: recipeProcesses[index],
          favImage: recipeImages[index],
          favCalories: recipeCalories[index],
          documentId: favoriteRecipeIds[index],
        );
      },
    );
  }
}

class FavoritePostsList extends StatelessWidget {
  const FavoritePostsList({
    super.key,
    required this.socialProvider,
  });

  final FavoriteSocialProvider socialProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: socialProvider.favoritePost.length,
      itemBuilder: (context, index) {
        final bookmarkItem = socialProvider.favoritePost[index];
        return FavoriteSocialItem(
          socialPost: bookmarkItem,
          socialProvider: socialProvider,
        );
      },
    );
  }
}
