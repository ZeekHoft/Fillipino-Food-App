import 'package:flilipino_food_app/pages/favorite/favorite_social_provider.dart';
import 'package:flilipino_food_app/pages/social/social_widgets/social_vew_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteSocialItem extends StatefulWidget {
  final bool screenState;
  final Map post;
  // this way map can or cannot be required in favorite_page (this only needs to be displayed)
  //or in post_widget page (this needs data to be passed here)
  const FavoriteSocialItem({
    super.key,
    required this.screenState,
    required this.post,
  });

  @override
  State<FavoriteSocialItem> createState() => _FavoriteSocialItemState();
}

class _FavoriteSocialItemState extends State<FavoriteSocialItem> {
  @override
  void initState() {
    super.initState();
    // Use `WidgetsBinding.instance.addPostFrameCallback` to ensure the build context is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoriteSocialProvider>(context, listen: false)
          .loadSocialFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteSocialProvider>(context);
    final favoriteSocialPost = favoriteProvider.favoritePost;

    // if (favoriteSocialPost.isEmpty) {
    //   return const Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         DappliProgressIndicator(),
    //         SizedBox(height: 10),
    //         Text("Loading favorite social posts...")
    //       ],
    //     ),
    //   );
    // }

    if (widget.screenState == true) {
      return ListView.builder(
          itemCount: favoriteSocialPost.length,
          itemBuilder: (context, index) {
            final postContent = favoriteSocialPost[index];
            //this contains all the paramenters ingredients, process etc...
            //widge.screenState, widget makes it accessible for the req parameters
            //within the stateclass to be used in the buildcontext
            return GestureDetector(
              onTap: () {
                // instead of passing widget.post we specified the type of data to pass
                // because in the favorite_page.dart the favorite_social_item doesnt take
                // post.wdiget its empty so we directly pass it here
                final postDataMap = {
                  "postId": postContent.postId,
                  "ingredients": postContent.ingredient
                      .split(',')
                      .map((s) => s.trim())
                      .toList(),
                  "processSteps": postContent.processSteps
                      .split(',')
                      .map((s) => s.trim())
                      .toList(),
                  "postDescription": postContent.description,
                  "calories": postContent.calories,
                  "postUsername": postContent.username,
                };
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FavoriteSocialItem(
                        screenState: false, post: postDataMap)));
              },
              child: Card(
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
                    Center(
                      child: Column(
                        children: [
                          Text(
                            ' ${postContent.username}',
                            style: const TextStyle(color: Colors.brown),
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
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.bookmark_remove,
                            color: Colors.red),
                        onPressed: () {
                          // Use toggleSocialFavorite to remove the item
                          favoriteProvider.toggleSocialFavorite(
                            postContent.postId,
                            postContent.ingredient,
                            postContent.processSteps,
                            postContent.description,
                            postContent.calories,
                            postContent.username,
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
              ),
            );
          });
    } else {
      return SocialVewPost(post: widget.post);
    }
  }
}
