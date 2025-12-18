import 'package:flilipino_food_app/pages/favorite/favorite_social_provider.dart';
import 'package:flilipino_food_app/pages/social/social_widgets/social_vew_post.dart';
import 'package:flutter/material.dart';

class FavoriteSocialItem extends StatelessWidget {
  // this way map can or cannot be required in favorite_page (this only needs to be displayed)
  //or in post_widget page (this needs data to be passed here)
  const FavoriteSocialItem({
    super.key,
    required this.socialPost,
    required this.socialProvider,
  });
  final SocialPost socialPost;
  final FavoriteSocialProvider socialProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // instead of passing widget.post we specified the type of data to pass
        // because in the favorite_page.dart the favorite_social_item doesnt take
        // post.wdiget its empty so we directly pass it here
        final postDataMap = {
          "postId": socialPost.postId,
          "ingredients":
              socialPost.ingredient.split(',').map((s) => s.trim()).toList(),
          "processSteps":
              socialPost.processSteps.split(',').map((s) => s.trim()).toList(),
          "postDescription": socialPost.description,
          "calories": socialPost.calories,
          "postUsername": socialPost.username,
        };
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SocialVewPost(post: postDataMap),
          ),
        );
      },
      child: ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              socialPost.description.isEmpty
                  ? 'No Description'
                  : socialPost.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: Opacity(
                opacity: 0.4,
                child: Text(
                  socialPost.processSteps,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            )
          ],
        ),
        subtitle: Opacity(
          opacity: 0.8,
          child: Text(
            socialPost.username,
          ),
        ),
        trailing: IconButton.filled(
          icon: Icon(Icons.bookmark_remove,
              color: Theme.of(context).colorScheme.error),
          style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer),
          onPressed: () {
            // Use toggleSocialFavorite to remove the item
            socialProvider.toggleSocialFavorite(
              socialPost.postId,
              socialPost.ingredient,
              socialPost.processSteps,
              socialPost.description,
              socialPost.calories,
              socialPost.username,
            );
            // Optional: Show a small confirmation snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Removed from favorites!')),
            );
          },
        ),
      ),
    );
  }
}
