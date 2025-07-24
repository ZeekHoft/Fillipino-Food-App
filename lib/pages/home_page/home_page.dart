import 'package:flilipino_food_app/pages/home_page/home_widgets/recipe_feed.dart';
import 'package:flilipino_food_app/pages/home_page/user_profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        // padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shrinkWrap: true,
        children: [
          const UserProfile(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Recipes",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: RecipeFeed(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
