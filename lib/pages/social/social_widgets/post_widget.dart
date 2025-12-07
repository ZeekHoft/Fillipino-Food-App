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
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(),
                  const SizedBox(width: 4.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            : ""),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Picture Here
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                            height: 300,
                            clipBehavior: Clip.antiAlias,
                            child: widget.post["postPic"] != null ||
                                    widget.post["postPic"] != ""
                                ? Image.asset(
                                    "assets/dappli_logo.png",
                                    fit: BoxFit.cover,
                                  )
                                // Image.network(
                                //     widget.post["postPic"],
                                //     width: 50,
                                //     height: 50,
                                //     fit: BoxFit.fitWidth,
                                //   )
                                : const Icon(Icons.image_not_supported),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            description,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Like Button
                        LikeButton(
                          postId: postId,
                          userId: currentUserId!,
                          likedAccounts: widget.post["likedAccounts"],
                        ),

                        const SizedBox(height: 8.0),

                        SaveButton(post: widget.post, provider: provider),

                        const SizedBox(height: 8.0),

                        // Share Button (unimplemented)
                        IconButton(onPressed: () {}, icon: Icon(Icons.share)),

                        const SizedBox(height: 8.0),

                        // THIS NEEDS TO BE REVIEWED FOR POTENTIAL ERRORS
                        // Delete Post Button
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
                                          style: TextStyle(color: Colors.red)),
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
                        // THIS NEEDS TO BE REVIEWED FOR POTENTIAL ERRORS
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.postId,
    required this.userId,
    required this.likedAccounts,
  });

  final String postId;
  final String userId;
  final Set? likedAccounts;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    bool likeState = false;

    if (widget.likedAccounts != null) {
      likeState = widget.likedAccounts!.contains(widget.userId);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                Provider.of<SocialDataStoring>(context, listen: false)
                    .triggerLike(
                  widget.postId,
                  widget.userId,
                  widget.likedAccounts!,
                );
              });
              print("changed: ${widget.postId}");
            },
            icon: likeState
                ? Icon(
                    Icons.favorite,
                    color: Theme.of(context).colorScheme.error,
                  )
                : Icon(Icons.favorite_border)),
        // Like Count
        Text(
          widget.likedAccounts != null && widget.likedAccounts!.isNotEmpty
              ? widget.likedAccounts!.length.toString()
              : "0",
        ),
      ],
    );
  }
}

class SaveButton extends StatefulWidget {
  const SaveButton({super.key, required this.post, required this.provider});

  final Map post;
  final FavoriteSocialProvider provider;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    final postId = widget.post['postID'];

    final ingredients = widget.post["ingredients"] as List<String>? ?? [];
    final processSteps = widget.post["processSteps"] as List<String>? ?? [];
    final calories = widget.post["calories"].toString();
    final description = widget.post["postDescription"] ?? "";
    final username = widget.post["postUsername"] ?? "N/A username";

    return IconButton(
      onPressed: () {
        setState(() {
          widget.provider.toggleSocialFavorite(
            postId.toString(),
            ingredients.join(', '),
            processSteps.join(', '),
            description,
            int.tryParse(calories) ?? 0,
            username,
          );
        });
      },
      icon: widget.provider
              .isSocialExist(widget.post["postID"]?.toString() ?? '')
          ? Icon(Icons.bookmark, color: Theme.of(context).colorScheme.secondary)
          : const Icon(
              Icons.bookmark_add_outlined,
            ),
    );
  }
}
