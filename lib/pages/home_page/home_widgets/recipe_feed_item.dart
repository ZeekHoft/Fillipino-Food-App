import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flilipino_food_app/pages/home_page/home_widgets/display_recipe.dart';
import 'package:flutter/material.dart';

class RecipeFeedItem extends StatelessWidget {
  RecipeFeedItem({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.ingredients,
    required this.process,
    required this.calories,
    required this.documentId,
  });

  final String name;
  final String imageUrl;
  final List<dynamic> ingredients;
  final List<dynamic> process;
  final int calories;
  final String documentId;

  @override
  Widget build(BuildContext context) {
    // final profileDataStoring = context.watch<ProfileDataStoring>();
    // final provider = Provider.of<FavoriteProvider>(context);

    // final userCalorieLimit = profileDataStoring.caloriesLimit;
    // final userAllergies = profileDataStoring.allergies;
    // final userEmail = profileDataStoring.email;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayRecipe(
              recipeName: name,
              recipeIngredients: ingredients,
              recipeProcess: process,
              recipeImage: imageUrl,
              recipeCalories: calories,
              documentId: documentId,
            ),
          ),
        );
      },
      child: Card.filled(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  factory RecipeFeedItem.fromDocumentSnapshot(QueryDocumentSnapshot recipeDoc) {
    final data = recipeDoc.data() as Map<String, dynamic>;
    final initialIngredients = data['ingredinets'] as List<dynamic>?;
    final initialProcess = data['process'] as List<dynamic>?;

    return RecipeFeedItem(
      name: recipeDoc['name'].toString(),
      imageUrl: recipeDoc['image'].toString(),
      ingredients: initialIngredients ?? [],
      process: initialProcess ?? [],
      calories: recipeDoc['calories'],
      documentId: recipeDoc.id,
    );
  }
}

/* OLD CODE
class OldRecipeItem extends StatelessWidget {
  const OldRecipeItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.calories,
    required this.userCalorieLimit,
    required this.provider,
    required this.documentId,
    required this.ingredients,
    required this.process,
  });

  final String imageUrl;
  final String name;
  final int calories;
  final int userCalorieLimit;
  final FavoriteProvider provider;
  final String documentId;
  final String ingredients;
  final String process;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.4, 1])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Text(calories.toString()),
                  if (displayCalorieWarning(calories, userCalorieLimit) != null)
                    displayCalorieWarning(calories, userCalorieLimit)!
                ],
              ),
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            end: 8.0,
            top: 8.0,
            child: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              child: IconButton(
                onPressed: () {
                  // passing documentId as the first argument to toggleFavorite
                  provider.toggleFavorite(documentId, name, imageUrl, calories,
                      ingredients, process);
                },
                icon: provider.isExist(documentId)
                    ? Icon(
                        Icons.bookmark,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : const Icon(Icons.bookmark_add_outlined),
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          )
        ],
      ),
    );
  }
}
*/

// display warning for calorie limit
Widget? displayCalorieWarning(int calories, int userCalorieLimit) {
  if (calories > userCalorieLimit) {
    return const Icon(
      Icons.fastfood_outlined,
      color: Colors.pink,
    );
  }
  return null;
}


// Widget? displayAllergyWarning() {
//   if () {
//     return const Icon(
//       Icons.fastfood_outlined,
//       color: Colors.pink,
//     );
//   }
//   return null;
// }