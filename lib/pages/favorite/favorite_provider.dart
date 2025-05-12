import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<String> _recipeName = [];
  final List<int> _recipeCalories = [];
  final List<String> _recipeImage = [];
  final List<String> _recipeIngredients = [];
  final List<String> _recipeProcess = [];

  List<String> get recipeName => _recipeName;
  List<String> get recipeImage => _recipeImage;
  List<int> get recipeCalories => _recipeCalories;
  List<String> get recipeIngredients => _recipeIngredients;
  List<String> get recipeProcess => _recipeProcess;

  void _saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("recipe name", _recipeName);
    await prefs.setStringList("recipe image", _recipeImage);

    await prefs.setStringList(
      "recipe calories",
      _recipeCalories.map((e) => e.toString()).toList(),
    );
    await prefs.setStringList("recipe ingredients", _recipeIngredients);
    await prefs.setStringList("recipe process", _recipeProcess);
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recipeName.clear();
    _recipeImage.clear();
    _recipeIngredients.clear();
    _recipeCalories.clear();
    _recipeProcess.clear();

    _recipeName.addAll(prefs.getStringList("recipe name") ?? []);
    _recipeImage.addAll(prefs.getStringList("recipe image") ?? []);

    List<String> calorieStrings = prefs.getStringList("recipe calories") ?? [];
    _recipeCalories.addAll(calorieStrings.map((e) => int.tryParse(e) ?? 0));
    _recipeIngredients.addAll(prefs.getStringList("recipe ingredients") ?? []);
    _recipeProcess.addAll(prefs.getStringList("recipe ingredients") ?? []);

    notifyListeners();
  }

//Honestly idk... HAHAAH all i know is it bases on index place rather then the values themselve
//by doing that it can be more precise, -1 becuase u know... 0 is 1
  void toggleFavorite(String name, String image, int calories,
      String ingredient, String process) {
    final index = _recipeName.indexOf(name);
    if (index != -1) {
      _recipeName.removeAt(index);
      _recipeImage.removeAt(index);
      _recipeCalories.removeAt(index);
      _recipeIngredients.removeAt(index);
      _recipeProcess.removeAt(index);
    } else {
      _recipeName.add(name);
      _recipeImage.add(image);
      _recipeCalories.add(calories);
      _recipeIngredients.add(ingredient);
      _recipeProcess.add(ingredient);
    }
    _saveValue();

    notifyListeners();
  }

  bool isExist(String name) {
    return _recipeName.contains(
        name); // checks for only 1 positional argument to toggle the icon button in display page
  }
}
