import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<String> _recipeName = [];
  final List<String> _recipeImage = [];

  List<String> get recipeName => _recipeName;
  List<String> get recipeImage => _recipeImage;

  void _saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("recipe name", _recipeName);
    await prefs.setStringList("recipe image", _recipeImage);
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recipeName.clear();
    _recipeImage.clear();
    _recipeName.addAll(prefs.getStringList("recipe name") ?? []);
    _recipeImage.addAll(prefs.getStringList("recipe image") ?? []);
    notifyListeners();
  }

  void toggleFavorite(String recipeName, String recipeImage) {
    final isExist = _recipeName.contains(recipeName);
    if (isExist) {
      _recipeName.remove(recipeName);
      _recipeImage.remove(recipeImage);
    } else {
      _recipeName.add(recipeName);
      _recipeImage.add(recipeImage);
    }
    _saveValue();

    notifyListeners();
  }

  bool isExist(String recipeName, String recipeImage) {
    final isExist = _recipeName.contains(recipeName) &&
        _recipeImage.contains(recipeImage.toString());
    return isExist;
  }
}
