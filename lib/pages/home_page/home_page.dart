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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Recipes",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: RecipeFeed(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
