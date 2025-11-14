// pic, ingreidents, process, save post

import 'package:flutter/material.dart';

class SocialVewPost extends StatelessWidget {
  final Map post;
  const SocialVewPost({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final ingredients = post["ingredients"] as List<dynamic>? ?? [];
    final processSteps = post["processSteps"] as List<dynamic>? ?? [];
    final description = post["postDescription"] as String? ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: false,
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Text(description),
                Text(processSteps.join(", ")),
                Text(ingredients.join(", ")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
