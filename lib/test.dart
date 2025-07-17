// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart'; // For kDebugMode
// import 'package:flutter/material.dart';

// class FavoriteProvider extends ChangeNotifier {
//   final List<String> _recipeName = [];
//   final List<int> _recipeCalories = [];
//   final List<String> _recipeImage = [];
//   final List<String> _recipeIngredients = [];
//   final List<String> _recipeProcess = [];
//   final List<String> _favoriteRecipeIds = [];

//   List<String> get recipeName => _recipeName;
//   List<String> get recipeImage => _recipeImage;
//   List<int> get recipeCalories => _recipeCalories;
//   List<String> get recipeIngredients => _recipeIngredients;
//   List<String> get recipeProcess => _recipeProcess;
//   List<String> get favoriteRecipeIds => _favoriteRecipeIds;

//   // Private method to handle adding/removing favorite IDs in Firestore
//   // FIX: Ensured the logic for Firestore interaction is correctly placed
//   // FIX: Added a comprehensive try-catch block
//   Future<void> _updateFavoritesInFireBase(String docId, bool isAdding) async {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     // FIX: Early exit if no valid user, preventing subsequent code from running incorrectly
//     if (currentUser == null || currentUser.email == null) {
//       if (kDebugMode) {
//         print(
//             "User not logged in or email not available. Cannot update favorites in Firebase.");
//       }
//       return;
//     }

//     try {
//       // FIX: Changed collection name to 'users_data' for consistency with SignupPage
//       final userDocQuery = await FirebaseFirestore.instance
//           .collection('users_data') // Corrected collection name
//           .where('email', isEqualTo: currentUser.email)
//           .limit(1)
//           .get();

//       if (userDocQuery.docs.isEmpty) {
//         if (kDebugMode) {
//           print(
//               "User data document not found for email: ${currentUser.email}. Cannot update favorites.");
//         }
//         // You might consider creating the user data document here if it's expected
//         // to exist by this point based on your app's flow (e.g., if signup guarantees it).
//         return;
//       }

//       final userDocRef = userDocQuery.docs.first.reference;

//       if (isAdding) {
//         // Add the recipe ID to the 'favorites' array field
//         await userDocRef.update({
//           'favorites': FieldValue.arrayUnion([docId]),
//         });
//         if (kDebugMode) {
//           print("Added $docId to Firestore favorites for ${currentUser.email}");
//         }
//       } else {
//         // Remove the recipe ID from the 'favorites' array field
//         await userDocRef.update({
//           'favorites': FieldValue.arrayRemove([docId]),
//         });
//         if (kDebugMode) {
//           print(
//               "Removed $docId from Firestore favorites for ${currentUser.email}");
//         }
//       }
//     } catch (e) {
//       // FIX: Proper catch block for errors during Firestore operations
//       if (kDebugMode) {
//         print("Error updating favorites in Firebase: $e");
//       }
//       // You might want to handle this error more gracefully in a real app (e.g., show a snackbar)
//     }
//   }

//   // Modified loadFavorites to fetch from Firestore
//   // FIX: Ensured consistency in collection name and improved error prints
//   void loadFavorites() async {
//     // Clear previous data, as we will re-fetch it based on IDs
//     _favoriteRecipeIds.clear();
//     _recipeName.clear();
//     _recipeImage.clear();
//     _recipeIngredients.clear();
//     _recipeCalories.clear();
//     _recipeProcess.clear();

//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null || currentUser.email == null) {
//       if (kDebugMode) {
//         print("User not logged in. Cannot load favorites from Firebase.");
//       }
//       notifyListeners(); // Notify listeners even if no user, to clear state
//       return;
//     }

//     try {
//       // FIX: Changed collection name to 'users_data' for consistency
//       final userDocQuery = await FirebaseFirestore.instance
//           .collection('users_data') // Corrected collection name
//           .where('email', isEqualTo: currentUser.email)
//           .limit(1)
//           .get();

//       if (userDocQuery.docs.isNotEmpty) {
//         final userData = userDocQuery.docs.first.data();
//         // Assuming 'favorites' is a List<dynamic> in Firestore
//         final List<dynamic> firestoreFavorites = userData['favorites'] ?? [];

//         // Add favorites from Firestore to the in-memory list
//         _favoriteRecipeIds
//             .addAll(firestoreFavorites.map((e) => e.toString()).toList());

//         // Now, fetch the full recipe details for each favorited ID
//         if (_favoriteRecipeIds.isNotEmpty) {
//           final recipeCollection =
//               FirebaseFirestore.instance.collection('recipes');
//           for (String docId in _favoriteRecipeIds) {
//             try {
//               DocumentSnapshot doc = await recipeCollection.doc(docId).get();
//               if (doc.exists) {
//                 Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//                 _recipeName.add(data['name'] as String);
//                 _recipeImage.add(data['image'] as String);
//                 _recipeCalories.add(data['calories'] as int);
//                 _recipeIngredients.add(data['ingredients'] as String);
//                 _recipeProcess.add(data['process'] as String);
//               } else {
//                 if (kDebugMode) {
//                   print(
//                       'Recipe document with ID ${docId} not found in Firebase. It might have been deleted.');
//                 }
//                 // Optional: You might want to remove this invalid docId from the user's favorites in Firestore here
//                 // if it no longer corresponds to an existing recipe.
//               }
//             } catch (e) {
//               if (kDebugMode) {
//                 print('Error fetching recipe document $docId: $e');
//               }
//             }
//           }
//         }
//       } else {
//         if (kDebugMode) {
//           print(
//               "User data document not found for email: ${currentUser.email}. No favorites to load.");
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error loading favorites from Firebase: $e");
//       }
//     } finally {
//       notifyListeners();
//     }
//   }

//   void toggleFavorite(String docId, String name, String image, int calories,
//       String ingredient, String process) {
//     final bool isCurrentlyFavorite = _favoriteRecipeIds.contains(docId);

//     if (isCurrentlyFavorite) {
//       // Logic for REMOVING a favorite from in-memory lists
//       _favoriteRecipeIds.remove(docId);

//       // Your existing logic for index-based removal
//       final index = _recipeName.indexOf(name);
//       if (index != -1) {
//         _recipeName.removeAt(index);
//         _recipeImage.removeAt(index);
//         _recipeCalories.removeAt(index);
//         _recipeIngredients.removeAt(index);
//         _recipeProcess.removeAt(index);
//       }
//       // FIX: Call the Firestore update method for removal
//       _updateFavoritesInFireBase(docId, false);
//     } else {
//       // Logic for ADDING a favorite to in-memory lists
//       _favoriteRecipeIds.add(docId);
//       _recipeName.add(name);
//       _recipeImage.add(image);
//       _recipeCalories.add(calories);
//       _recipeIngredients.add(ingredient);
//       // FIX: Corrected typo - store 'process' not 'ingredient' again
//       _recipeProcess.add(process);

//       // FIX: Call the Firestore update method for addition
//       _updateFavoritesInFireBase(docId, true);
//     }

//     notifyListeners();
//   }

//   bool isExist(String docId) {
//     return _favoriteRecipeIds.contains(docId);
//   }
// }
