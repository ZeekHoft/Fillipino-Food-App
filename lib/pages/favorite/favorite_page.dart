import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({
    super.key,
  });

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
                      .map((recName) => Text(
                            recName,
                            style: const TextStyle(fontSize: 24),
                          ))
                      .toList(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipeImage
                      .map((recImg) => Image.network(recImg))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
