import 'package:flilipino_food_app/pages/home_page/home_widgets/recipe_feed_item.dart';
import 'package:flilipino_food_app/themes/color_themes.dart';
import 'package:flilipino_food_app/util/recipe_stream_builder.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/display_recipe.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeFeed extends StatefulWidget {
  const RecipeFeed({super.key});

  @override
  State<RecipeFeed> createState() => _RecipeFeedState();
}

class _RecipeFeedState extends State<RecipeFeed> {
  @override
  Widget build(BuildContext context) {
    final recipeStream = RecipeStreamBuilder.of(context)!.recipeStream;

    return StreamBuilder<QuerySnapshot>(
      stream: recipeStream,
      builder: (context, snapshot) {
        List<Widget> recipeWidgets = [];

        if (snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.yellowTheme,
          ));
        } else if (snapshot.hasData || snapshot.data != null) {
          final recipeDocs = snapshot.data?.docs.reversed.toList();

          for (var recipeDoc in recipeDocs!) {
            final String documentId = recipeDoc.id;
            final recipeWidget = RecipeFeedItem(
              name: recipeDoc['name'].toString(),
              imageUrl: recipeDoc['image'].toString(),
              ingredients: recipeDoc['ingredients'].toString(),
              process: recipeDoc['process'].toString(),
              calories: recipeDoc['calories'],
              documentId: documentId,
            );
            recipeWidgets.add(recipeWidget);
          }
        }
        return GridView.count(
          shrinkWrap: true,
          mainAxisSpacing: 24,
          crossAxisSpacing: 16,
          crossAxisCount: 2,
          children: recipeWidgets,
        );
      },
    );
  }
}
