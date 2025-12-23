import 'package:flilipino_food_app/pages/favorite/favorite_social_provider.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({super.key, required this.post, required this.provider});

  final Map post;
  final FavoriteSocialProvider provider;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final postId = widget.post['postID'];

    final ingredients = widget.post["ingredients"] as List<String>? ?? [];
    final processSteps = widget.post["processSteps"] as List<String>? ?? [];
    final calories = widget.post["calories"].toString();
    final description = widget.post["postDescription"] ?? "";
    final username = widget.post["postUsername"] ?? "N/A username";
    final timestamp = widget.post["dateTimePost"] as DateTime;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: _isLoading
          ? const FavoriteProgressIndicator()
          : IconButton(
              onPressed: () {
                setState(
                  () {
                    widget.provider.toggleSocialFavorite(
                      postId.toString(),
                      ingredients.join(', '),
                      processSteps.join(', '),
                      description,
                      int.tryParse(calories) ?? 0,
                      username,
                      Timestamp.fromDate(timestamp),
                    );
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                );
              },
              icon: widget.provider.isSocialExist(
                widget.post["postID"]?.toString() ?? '',
              )
                  ? Icon(Icons.bookmark, color: Colors.amber.shade600)
                  : const Icon(Icons.bookmark_add_outlined),
            ),
    );
  }
}
