import 'package:flilipino_food_app/pages/home_page/home_widgets/profile_section.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/recipe_feed.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        shrinkWrap: true,
        children: [
          // const ProfileSection(),
          const SizedBox(height: 24),
          Text(
            "Recipes",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          const RecipeFeed(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
