import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.post,
  });

  final Map post;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
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
                  child: post["postPic"] != null || post["postPic"] != ""
                      ? Image.network(
                          post["postPic"],
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
                          child: Text(post["dateTimePost"] != null
                              ? DateFormat("MM/dd/yyyy")
                                  .format(post["dateTimePost"])
                              : "")),
                      const SizedBox(height: 8.0),
                      Text(post["postDescription"] ?? ""),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Like Button
                          Row(
                            children: [
                              Icon(Icons.favorite_border),
                              SizedBox(width: 4),
                              Text("${post["likeCount"] ?? "0"}"),
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
    );
  }
}
