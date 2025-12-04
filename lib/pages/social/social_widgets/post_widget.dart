import 'package:flilipino_food_app/pages/favorite/favorite_social_item.dart';
import 'package:flilipino_food_app/pages/favorite/favorite_social_provider.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';
import 'package:flilipino_food_app/util/social_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.post,
  });

  final Map post;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteSocialProvider>(context);
    final profileDataStoring = context.read<ProfileDataStoring>();

    bool likeState = false;
    if (widget.post["likedAccounts"] != null) {
      likeState =
          widget.post["likedAccounts"].contains(profileDataStoring.userId!);
    }
    final postId = widget.post['postID'];

    final ingredients = widget.post["ingredients"] as List<String>? ?? [];
    final processSteps = widget.post["processSteps"] as List<String>? ?? [];
    final calories = widget.post["calories"].toString();
    final description = widget.post["postDescription"] ?? "";
    final username = widget.post["postUsername"] ?? "N/A username";

    final socialDataStoring = context.read<SocialDataStoring>();
    final favoriteProvider = context.read<FavoriteSocialProvider>();
    final currentUserId = profileDataStoring.userId;
    final postUserId = widget.post["userId"];
    final isPostOwner = currentUserId != null && currentUserId == postUserId;
    // print(widget.post);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                FavoriteSocialItem(screenState: false, post: widget.post)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Picture Here
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black54,
                    ),
                    height: 300,
                    clipBehavior: Clip.antiAlias,
                    child: widget.post["postPic"] != null ||
                            widget.post["postPic"] != ""
                        ? Image.network(
                            widget.post["postPic"],
                            width: 50,
                            height: 50,
                            fit: BoxFit.fitWidth,
                          )
                        : const Icon(Icons.image_not_supported),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          username,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Opacity(
                            opacity: 0.8,
                            child: Text(widget.post["dateTimePost"] != null
                                ? DateFormat("MM/dd/yyyy")
                                    .format(widget.post["dateTimePost"])
                                : "")),
                        const SizedBox(height: 8.0),
                        Text(description),
                        if (ingredients.isNotEmpty) ...[
                          Text(
                            "Ingredients:",
                          ),
                          Text(
                            ingredients.join(", "),
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(height: 4),
                        Text("Total Calories: $calories"),
                        SizedBox(height: 4),
                        if (processSteps.isNotEmpty) ...[
                          Text(
                            "Process:",
                          ),
                          Text(
                            processSteps.join(", "),
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Like Button
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        Provider.of<SocialDataStoring>(context,
                                                listen: false)
                                            .triggerLike(
                                                widget.post["postID"]!,
                                                profileDataStoring.userId!,
                                                widget.post["likedAccounts"]!);
                                      });
                                      print("changed: ${widget.post}");
                                    },
                                    icon: likeState
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.favorite_border)),
                                SizedBox(width: 4),
                                Text(
                                    "${widget.post["likedAccounts"] != null ? widget.post["likedAccounts"].length : " "}"),
                              ],
                            ),

                            IconButton(
                              onPressed: () {
                                provider.toggleSocialFavorite(
                                  postId.toString(),
                                  ingredients.join(', '),
                                  processSteps.join(', '),
                                  description,
                                  int.tryParse(calories) ?? 0,
                                  username,
                                );
                              },
                              icon: provider.isSocialExist(
                                      widget.post["postID"]?.toString() ?? '')
                                  ? const Icon(
                                      Icons.bookmark,
                                      color: Colors
                                          .red, // Or your AppColors.yellowTheme
                                    )
                                  : const Icon(
                                      Icons.bookmark_add_outlined,
                                    ),
                            ),

                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.share)),
                            // THIS NEEDS TO BE REVIEWED FOR POTENTIAL ERRORS

                            if (isPostOwner)
                              IconButton(
                                onPressed: () async {
                                  // Confirmation dialog is highly recommended here!
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Post'),
                                      content: const Text(
                                          'Are you sure you want to delete this post? This cannot be undone.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                        ),
                                        TextButton(
                                          child: const Text('Delete',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    // Call the delete function from the provider
                                    await socialDataStoring.deletePost(
                                        postId!, favoriteProvider);
                                  }
                                },
                                icon: const Icon(Icons.delete_forever,
                                    color: Colors.red),
                              ),

                            // THIS NEEDS TO BE REVIEWD FOR POTENTIAL ERRORS
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.widget,
  });

  final PostWidget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
        SizedBox(width: 4),
        Text(
            "${widget.post["likedAccounts"] != null ? widget.post["likedAccounts"].length : " "}"),
      ],
    );
  }
}
