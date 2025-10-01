import 'package:flilipino_food_app/pages/home_page/home_widgets/recipe_feed_item.dart';
import 'package:flilipino_food_app/themes/color_themes.dart';
import 'package:flilipino_food_app/util/recipe_stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeFeed extends StatefulWidget {
  final dynamic userData;

  const RecipeFeed({super.key, this.userData});

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
        if (snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.yellowTheme,
              ),
            ),
          );
        } else if (snapshot.hasData || snapshot.data != null) {
          return SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              crossAxisSpacing: 4,
              mainAxisSpacing: 8,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return RecipeFeedItem.fromDocumentSnapshot(
                snapshot.data!.docs[index],
              );
            },
          );
        } else {
          // Finished fetching but snapshot has no data
          return const SliverToBoxAdapter(
            child: Center(
              child: Text("No recipes available"),
            ),
          );
        }
      },
    );
  }
}
