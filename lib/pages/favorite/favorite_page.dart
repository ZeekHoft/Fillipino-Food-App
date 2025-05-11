import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/display_recipe.dart';
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
      body: ListView.builder(
        itemCount: recipeName.length,
        itemBuilder: (context, index) {
          final name =
              recipeName[index]; //itterate through the list to get their index
          final image = recipeImage[index];

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DisplayRecipe(
                      recipeName: name,
                      recipeIngredients: "recipeIngredients",
                      recipeProcess: "recipeProcess",
                      recipeImage: image)));
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(children: [
                          const SizedBox(height: 16),
                          Text(name),
                          Image.network(image)
                        ])
                      ]),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
