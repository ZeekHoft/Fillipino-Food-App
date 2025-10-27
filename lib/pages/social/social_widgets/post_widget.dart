import 'package:flilipino_food_app/pages/social/social_widgets/social_vew_post.dart';
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
    final profileDataStoring = context.read<ProfileDataStoring>();
    bool likeState = false;
    if (widget.post["likedAccounts"] != null) {
      likeState =
          widget.post["likedAccounts"].contains(profileDataStoring.userId!);
    }
    final ingredients = widget.post["ingredients"] as List<String>? ?? [];
    final processSteps = widget.post["processSteps"] as List<String>? ?? [];
    final calories = widget.post["calories"].toString();

    // print(widget.post);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SocialVewPost(
            post: widget.post,
          ),
        ));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Picture Here
                Expanded(
                  flex: 4,
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
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Poster Username",
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
                        Text(widget.post["postDescription"] ?? ""),
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
                        SizedBox(child: Text("Total Calories: $calories")),
                        const Spacer(),
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
                            Icon(Icons.bookmark_border),
                            Icon(Icons.share),
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
