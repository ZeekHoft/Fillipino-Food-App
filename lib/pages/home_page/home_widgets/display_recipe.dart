import 'package:flilipino_food_app/pages/favorite/favorite_provider.dart';
import 'package:flilipino_food_app/themes/app_theme.dart';
import 'package:flilipino_food_app/themes/color_themes.dart';
import 'package:flilipino_food_app/util/profile_data_storing.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayRecipe extends StatefulWidget {
  final String recipeName, recipeImage;
  final List<dynamic> recipeIngredients, recipeProcess;
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
  bool _exceedCalorie(int calorieLimit, int calorieRecipe) {
    if (calorieLimit >= calorieRecipe) {
      return true;
    }
    return false;
  }

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
      if (RegExp(r'\b' + RegExp.escape(allergen) + r'\b')
          .hasMatch(ingredientsLower)) {
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
      if (RegExp(r'\b' + RegExp.escape(allergen) + r'\b')
          .hasMatch(ingredientsLower)) {
        detectedAllergens.add(allergen);
      }
    }

    return detectedAllergens;
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    // final userEmail = context.watch<ProfileDataStoring>();
    final profileDataStoring = context.watch<ProfileDataStoring>();
    final allergies = profileDataStoring.allergies;
    final userCalorieLimit = profileDataStoring.caloriesLimit;
    final calories = profileDataStoring.caloriesLimit.toString();

    final ingredientsRecipes = widget.recipeIngredients.join(', ');
    final processRecipe = widget.recipeProcess.join(', ');

    final hasAllergen = _hasAllergen(ingredientsRecipes, allergies);
    final exceedsCalories =
        _exceedCalorie(widget.recipeCalories, userCalorieLimit);
    final detectedAllergens =
        _getDetectedAllergens(ingredientsRecipes, allergies);

    return Scaffold(
      // Extends body behind the app bar for the "Image at top" look
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparentTheme,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.whiteTheme,
            child: const BackButton(color: AppColors.blackTheme),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: AppColors.whiteTheme,
              child: _isLoading
                  ? const SizedBox(
                      width: 20, height: 20, child: FavoriteProgressIndicator())
                  : IconButton(
                      icon: Icon(
                        provider.isRecipeExist(widget.documentId)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: AppColors.yellowTheme,
                      ),
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        await provider.toggleRecipeFavorite(
                            widget.documentId,
                            widget.recipeName,
                            widget.recipeImage,
                            widget.recipeCalories,
                            widget.recipeIngredients,
                            widget.recipeProcess);
                        if (mounted) setState(() => _isLoading = false);
                      },
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HERO IMAGE
            Hero(
              tag: widget.documentId,
              child: Image.network(
                widget.recipeImage,
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Container(
              transform: Matrix4.translationValues(
                  0, -30, 0), // Pulls content over the image
              decoration: const BoxDecoration(
                color: AppColors.whiteTheme,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RECIPE TITLE
                  Text(
                    widget.recipeName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackTheme,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // CALORIE AND WARNING CHIPS
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.bolt,
                            size: 18, color: AppColors.orangeTheme),
                        label: Text("${widget.recipeCalories} kcal"),
                        backgroundColor: Colors.orange.shade50,
                      ),
                      if (exceedsCalories)
                        Chip(
                          avatar: const Icon(Icons.warning_amber_rounded,
                              size: 18, color: AppColors.redTheme),
                          label: const Text("High Calorie"),
                          backgroundColor: Colors.red.shade50,
                        ),
                    ],
                  ),

                  if (detectedAllergens.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.no_food,
                              color: AppColors.redTheme, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Allergen Alert: ${detectedAllergens.join(', ')}",
                              style: const TextStyle(
                                  color: AppColors.redTheme,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // INTERACTIVE BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showRecipeSheet(
                              context, ingredientsRecipes, processRecipe),
                          icon: const Icon(Icons.restaurant_menu),
                          label: const Text("View Recipe"),
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showNutritionSheet(context),
                          icon: const Icon(Icons.info_outline),
                          label: const Text("Nutrition"),
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // PREVIEW SECTION
                  Text("Ingredients Preview",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    ingredientsRecipes,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecipeSheet(BuildContext context, ingredients, process) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ingredients", style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 32),
            Text(ingredients, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            Text("Instructions", style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 32),
            Text(process, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showNutritionSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
              padding: EdgeInsetsGeometry.all(24.0),
              child: Column(
                children: [
                  Text("Nutritional Facts",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: 16,
                  ),
                  ListTile(
                    tileColor: AppColors.orangeTheme.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    leading: const Icon(Icons.local_fire_department,
                        color: AppColors.orangeTheme),
                    title: const Text("Total Calories"),
                    trailing: Text("${widget.recipeCalories} kcal",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
            ));
  }
}

// OLD CODE DESING
// class RecipeDetails extends StatelessWidget {
//   const RecipeDetails({
//     super.key,
//     required this.widget,
//   });

//   final DisplayRecipe widget;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text("Ingredients", style: Theme.of(context).textTheme.titleMedium),
//             Text(ingredientsRecipes),
//             const SizedBox(height: 16),
//             Text(
//               "Process",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             Text(widget.recipeProcess),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NutritionalDetails extends StatelessWidget {
//   const NutritionalDetails({super.key, required this.widget});

//   final DisplayRecipe widget;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text("Calories", style: Theme.of(context).textTheme.titleMedium),
//             Text(widget.recipeCalories.toString()),
//           ],
//         ),
//       ),
//     );
//   }
// }
