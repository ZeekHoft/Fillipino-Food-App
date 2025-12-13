// pic, ingreidents, process, save post

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SocialVewPost extends StatelessWidget {
  final Map post;
  const SocialVewPost({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 0,
    );

    final ingredients = post["ingredients"] as List<dynamic>? ?? [];
    final processSteps = post["processSteps"] as List<dynamic>? ?? [];
    final description = post["postDescription"] as String? ?? 'N/A';
    final calories = post["calories"] as int;

    final postPic = post["postPic"];
    final postDateTime = post["dateTimePost"];
    final postId = post['postID'];
    final postUserId = post["userId"];
    final username = post["postUsername"] ?? "N/A username";

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top part of post
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
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
                        child: Text(postDateTime != null
                            ? DateFormat("MM/dd/yyyy").format(postDateTime)
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
            ),
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              // height: 300,
              clipBehavior: Clip.antiAlias,
              child: postPic != null || postPic != ""
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Text("${formatter.format(calories)} calories"),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Ingredients",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (ingredients.isNotEmpty) ...[
                    Text(ingredients.join("\n")),
                  ],
                  SizedBox(height: 8),
                  Text(
                    "Process",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (processSteps.isNotEmpty) ...[
                    Text(processSteps.join("\n")),
                  ],
                ],
              ),
            ),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
