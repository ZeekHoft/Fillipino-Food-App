import 'package:flilipino_food_app/pages/favorite/favorite_social_provider.dart';
import 'package:flilipino_food_app/test2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteSocialItem extends StatelessWidget {
  const FavoriteSocialItem({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteSocialProvider>(context);
    final favoriteSocialPost = favoriteProvider.favoritePost;

    // Use `WidgetsBinding.instance.addPostFrameCallback` to ensure the build context is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (favoriteSocialPost.isEmpty) {
        favoriteProvider.loadSocialFavorites();
      }
    });
    return ListView.builder(
        itemCount: favoriteSocialPost.length,
        itemBuilder: (context, index) {
          final postContent = favoriteSocialPost[index];
          //this contains all the paramenters ingredients, process etc...

          return Card(
            child: Column(
              children: [
                Text(
                  postContent.description.isEmpty
                      ? 'No Description'
                      : postContent.description,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Ingredients: ${postContent.ingredient}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
                Text(
                  'Making Process: ${postContent.processSteps}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
                Text(
                  'Calories: ${postContent.calories}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_remove, color: Colors.red),
                    onPressed: () {
                      // Use toggleSocialFavorite to remove the item
                      favoriteProvider.toggleSocialFavorite(
                        postContent.postId,
                        postContent.ingredient,
                        postContent.processSteps,
                        postContent.description,
                        postContent.calories,
                      );
                      // Optional: Show a small confirmation snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Removed from favorites!')),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
