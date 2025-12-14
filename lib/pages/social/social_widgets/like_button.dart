import 'package:flilipino_food_app/util/social_data_storing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                    color: Colors.red.shade600,
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
