import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<String> _recipeName = [];
  List<String> get recipeName => _recipeName;

  void toggleFavorite(String recipeName) {
    final isExist = _recipeName.contains(recipeName);
    if (isExist) {
      _recipeName.remove(recipeName);
    } else {
      _recipeName.add(recipeName);
    }
    notifyListeners();
  }

  bool isExist(String recipeName) {
    final isExist = _recipeName.contains(recipeName);
    return isExist;
  }
}
