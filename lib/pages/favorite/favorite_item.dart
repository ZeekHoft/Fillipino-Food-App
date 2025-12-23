import 'package:flilipino_food_app/pages/home_page/home_widgets/display_recipe.dart';
import 'package:flutter/material.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({
    super.key,
    required this.favName,
    required this.favIngredient,
    required this.favProcess,
    required this.favImage,
    required this.favCalories,
    required this.documentId, // Add documentId
  });

  final String favName;
  final List<dynamic> favIngredient;
  final List<dynamic> favProcess;
  final String favImage;
  final int favCalories;
  final String documentId; // Store documentId

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayRecipe(
              recipeName: favName,
              recipeIngredients: favIngredient,
              recipeProcess: favProcess,
              recipeImage: favImage,
              recipeCalories: favCalories,
              documentId: documentId, // Pass documentId
            ),
          ),
        );
      },
      child: ListTile(
        leading: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            width: 52,
            height: 52,
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              favImage,
              fit: BoxFit.cover,
            )),
        title: Text("$favName"),
        subtitle: Opacity(opacity: 0.8, child: Text("Calories: $favCalories")),
      ),
    );
  }
}
