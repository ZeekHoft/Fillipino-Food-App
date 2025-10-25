import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flilipino_food_app/themes/color_themes.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayRecipe extends StatefulWidget {
  final String recipeName, recipeIngredients, recipeProcess, recipeImage;
  final int recipeCalories;
  final String documentId; // Add documentId here

  const DisplayRecipe(
      {super.key,
      required this.recipeName,
      required this.recipeIngredients,
      required this.recipeProcess,
      required this.recipeImage,
      required this.recipeCalories,
      required this.documentId // Require documentId
      });

  @override
  State<DisplayRecipe> createState() => _DisplayRecipeState();
}

class _DisplayRecipeState extends State<DisplayRecipe> {
  // Add this helper method in your _DisplayRecipeState class
bool _hasAllergen(String ingredients, String allergies) {
  if (allergies.isEmpty) return false;
  
  // Convert both to lowercase for case-insensitive comparison
  final ingredientsLower = ingredients.toLowerCase();
  
  // Split allergies by common separators (comma, semicolon, etc.)
  final allergenList = allergies
      .toLowerCase()
      .split(RegExp(r'[,;]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  
  // Check if any allergen appears in the ingredients
  for (final allergen in allergenList) {
    // Use word boundary check to avoid partial matches
    // e.g., "garlic" will match "garlic clove" but not "garlicky"
    if (RegExp(r'\b' + RegExp.escape(allergen) + r'\b').hasMatch(ingredientsLower)) {
      return true;
    }
  }
  
  return false;
}

// Get list of detected allergens for display
List<String> _getDetectedAllergens(String ingredients, String allergies) {
  if (allergies.isEmpty) return [];
  
  final ingredientsLower = ingredients.toLowerCase();
  final detectedAllergens = <String>[];
  
  final allergenList = allergies
      .toLowerCase()
      .split(RegExp(r'[,;]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  
  for (final allergen in allergenList) {
    if (RegExp(r'\b' + RegExp.escape(allergen) + r'\b').hasMatch(ingredientsLower)) {
      detectedAllergens.add(allergen);
    }
  }
  
  return detectedAllergens;
}
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    // final userEmail = context.watch<ProfileDataStoring>();
    final profileDataStoring = context.watch<ProfileDataStoring>();
    final allergies = profileDataStoring.allergies;

    
    final hasAllergen = _hasAllergen(widget.recipeIngredients, allergies);
    final detectedAllergens = _getDetectedAllergens(widget.recipeIngredients, allergies);



    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: false,
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.70,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    widget.recipeImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  widget.recipeName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                  // softWrap: true,
                ),
              ),
              IconButton(
                onPressed: () {
                  provider.toggleFavorite(
                    widget.documentId, // Pass the document ID
                    widget.recipeName,
                    widget.recipeImage,
                    widget.recipeCalories,
                    widget.recipeIngredients,
                    widget.recipeProcess,
                  );
                },
                icon: provider.isExist(
                        widget.documentId) // Check existence with document ID
                    ? const Icon(
                        Icons.bookmark,
                        color: AppColors.yellowTheme,
                      )
                    : const Icon(
                        Icons.bookmark_add_outlined,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Display allergen warning according to user
          // TODO: add logic

          if (hasAllergen)
          Center(
            child: Card(
              color: Theme.of(context).colorScheme.error,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
              
                    Icon(
                      Icons.warning,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                    Text(
                            "Contains: ${detectedAllergens.join(', ')}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    showDragHandle: true,
                    enableDrag: true,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => RecipeDetails(widget: widget),
                  );
                },
                child: const Text("Recipe"),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    showDragHandle: true,
                    enableDrag: true,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => NutritionalDetails(widget: widget),
                  );
                },
                child: const Text("Nutritional Facts"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeDetails extends StatelessWidget {
  const RecipeDetails({
    super.key,
    required this.widget,
  });

  final DisplayRecipe widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Ingredients", style: Theme.of(context).textTheme.titleMedium),
            Text(widget.recipeIngredients),
            const SizedBox(height: 16),
            Text(
              "Process",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(widget.recipeProcess),
          ],
        ),
      ),
    );
  }
}

class NutritionalDetails extends StatelessWidget {
  const NutritionalDetails({super.key, required this.widget});

  final DisplayRecipe widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Calories", style: Theme.of(context).textTheme.titleMedium),
            Text(widget.recipeCalories.toString()),
          ],
        ),
      ),
    );
  }
}
