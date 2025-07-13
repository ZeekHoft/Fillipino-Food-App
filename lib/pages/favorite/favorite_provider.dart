import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<String> _favoriteRecipeIds = [];

  final List<String> _recipeName = [];
  final List<int> _recipeCalories = [];
  final List<String> _recipeImage = [];
  final List<String> _recipeIngredients = [];
  final List<String> _recipeProcess = [];

  List<String> get favoriteRecipeIds => _favoriteRecipeIds;

  List<String> get recipeName => _recipeName;
  List<String> get recipeImage => _recipeImage;
  List<int> get recipeCalories => _recipeCalories;
  List<String> get recipeIngredients => _recipeIngredients;
  List<String> get recipeProcess => _recipeProcess;

  // Key for SharedPreferences
  static const String _favoritesKey = "favoriteRecipeIds";

  void _saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteRecipeIds);
    // Remove saving other details here, as they will be fetched dynamically
    // when needed from Firestore based on the stored IDs.
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favoriteRecipeIds.clear();
    _favoriteRecipeIds.addAll(prefs.getStringList(_favoritesKey) ?? []);
    // Clear previous data, as we will re-fetch it based on IDs

    _recipeName.clear();
    _recipeImage.clear();
    _recipeIngredients.clear();
    _recipeCalories.clear();
    _recipeProcess.clear();

    // we'll fetch the full recipe detail for each favorited ID
    if (_favoriteRecipeIds.isNotEmpty) {
      final recipeCollection = FirebaseFirestore.instance.collection('recipes');
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
            print('Document widh ID ${docId} not found in Firebase DBA');
          }
        } catch (e) {
          print('Error fetching document $docId: $e');
        }
      }
    }

    notifyListeners();
  }

  void toggleFavorite(String docId, String name, String image, int calories,
      String ingredient, String process) {
    if (_favoriteRecipeIds.contains(docId)) {
      _favoriteRecipeIds.remove(docId); // if already favorite remove this sht

      //Honestly idk... HAHAAH all i know is it bases on index place rather then the values themselve
      //by doing that it can be more precise, -1 becuase u know... 0 is 1

      final index = _recipeName.indexOf(name);
      if (index != -1) {
        _recipeName.removeAt(index);
        _recipeImage.removeAt(index);
        _recipeCalories.removeAt(index);
        _recipeIngredients.removeAt(index);
        _recipeProcess.removeAt(index);
      }
    } else {
      // If not a favorite, add the document ID
      _favoriteRecipeIds.add(docId);
      _recipeName.add(name);
      _recipeImage.add(image);
      _recipeCalories.add(calories);
      _recipeIngredients.add(ingredient);
      _recipeProcess.add(ingredient);
    }

    _saveValue();
    notifyListeners();
  }

  bool isExist(String docId) {
    return _favoriteRecipeIds.contains(
        docId); // checks for only 1 positional argument to toggle the icon button in display page
  }
}
