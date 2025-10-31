import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<String> _recipeName = [];
  final List<int> _recipeCalories = [];
  final List<String> _recipeImage = [];
  final List<String> _recipeIngredients = [];
  final List<String> _recipeProcess = [];
  final List<String> _favoriteRecipeIds = [];

  List<String> get recipeName => _recipeName;
  List<String> get recipeImage => _recipeImage;
  List<int> get recipeCalories => _recipeCalories;
  List<String> get recipeIngredients => _recipeIngredients;
  List<String> get recipeProcess => _recipeProcess;
  List<String> get favoriteRecipeIds => _favoriteRecipeIds;

  // Key for SharedPreferences
  // static const String _favoritesKey = "favoriteRecipeIds";

  //saving favorites in firebase

  //check if the user logged in has an email
  Future<void> _storeFavoriteInFireBase(String docId, bool isAdding) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      if (kDebugMode) {
        print(
            "User not logged in or email not available in DBA, user: $currentUser ");
      }
      return;
    }

    //attempt to try and find the email
    try {
      // add a try and except, exception for security
      final userDocQuery = await FirebaseFirestore.instance
          .collection('users_data')
          .where('email', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      //check if user found
      if (userDocQuery.docs.isEmpty) {
        if (kDebugMode) {
          print("User data document not found for email: ${currentUser.email}");
        }
        // You might want to create a user data document if it doesn't exist
        return;
      }
      final userDocRef =
          userDocQuery.docs.first.reference; //user has been found

      if (isAdding) {
        //adding
        // Add the recipe ID to the 'favorites' array field
        await userDocRef.update({
          'favorites': FieldValue.arrayUnion([docId]),
        });
        if (kDebugMode) {
          print("Added $docId to Firestore favorites for ${currentUser.email}");
        }
      } else {
        // removing
        // Remove the recipe ID from the 'favorites' array field
        await userDocRef.update({
          'favorites': FieldValue.arrayRemove([docId]),
        });
        if (kDebugMode) {
          print(
              "Removed $docId from Firestore favorites for ${currentUser.email}"); // improve error handling
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in updating firesoter: $e");
      }
    }
  }

  void loadFavorites() async {
    // Clear previous data, as we will re-fetch it based on IDs

    _favoriteRecipeIds.clear();
    _recipeName.clear();
    _recipeImage.clear();
    _recipeIngredients.clear();
    _recipeCalories.clear();
    _recipeProcess.clear();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      if (kDebugMode) {
        print("User not logged in. Cannot load favorites from Firestore.");
      }
      notifyListeners(); // Notify listeners even if no user, to clear state
      return;
    }
    try {
      final userDocQuery = await FirebaseFirestore.instance
          .collection('users_data')
          .where('email', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (userDocQuery.docs.isNotEmpty) {
        final userData = userDocQuery.docs.first.data();
        final List<dynamic> firestoreFavorites = userData['favorites'] ?? [];
        // Add favorites from Firestore to the in-memory list
        _favoriteRecipeIds
            .addAll(firestoreFavorites.map((e) => e.toString()).toList());

        // we'll fetch the full recipe detail for each favorited ID
        if (_favoriteRecipeIds.isNotEmpty) {
          final recipeCollection =
              FirebaseFirestore.instance.collection('recipes');
          for (String docId in _favoriteRecipeIds) {
            try {
              DocumentSnapshot doc = await recipeCollection.doc(docId).get();
              if (doc.exists) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                _recipeName.add(data['name'] as String);
                _recipeImage.add(data['image'] as String);
                _recipeCalories.add(data['calories'] as int);
                _recipeIngredients.add(data['ingredients'] as String);
                _recipeProcess.add(data['process'] as String);
              } else {
                // Handle cases where a favorited recipe might have been deleted from Firebase
                if (kDebugMode) {
                  print('Document widh ID ${docId} not found in Firebase DBA');
                }
              }
            } catch (e) {
              if (kDebugMode) {
                print('Error fetching document $docId: $e');
              }
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getting user data: $e");
      }
    } finally {
      notifyListeners();
    }
  }

  void toggleFavorite(String docId, String name, String image, int calories,
      String ingredient, String process) {
    if (_favoriteRecipeIds.contains(docId)) {
      _favoriteRecipeIds.remove(docId); // if already favorite remove this sht

      //Honestly idk... HAHAAH all i know is it bases on index place rather then the values themselve
      //by doing that it can be more precise, -1 becuase u know... 0 is 1

      final index = _recipeName.indexOf(name);
      // need changes here lets not assume the name is unique enough
      if (index != -1) {
        _recipeName.removeAt(index);
        _recipeImage.removeAt(index);
        _recipeCalories.removeAt(index);
        _recipeIngredients.removeAt(index);
        _recipeProcess.removeAt(index);
        _storeFavoriteInFireBase(docId, false);
      }
    } else {
      // If not a favorite, add the document ID
      _favoriteRecipeIds.add(docId);
      _recipeName.add(name);
      _recipeImage.add(image);
      _recipeCalories.add(calories);
      _recipeIngredients.add(ingredient);
      _recipeProcess.add(ingredient);
      _storeFavoriteInFireBase(docId, true);
    }

    notifyListeners();
  }

  bool isExist(String docId) {
    return _favoriteRecipeIds.contains(
        docId); // checks for only 1 positional argument to toggle the icon button in display page
  }
}
