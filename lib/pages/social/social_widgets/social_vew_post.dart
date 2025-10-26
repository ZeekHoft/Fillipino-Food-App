// pic, ingreidents, process, save post

import 'package:flilipino_food_app/pages/home_page/home_widgets/display_recipe.dart';
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
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: false,
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
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
