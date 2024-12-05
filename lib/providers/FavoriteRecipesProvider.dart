import 'package:flutter/material.dart';

class FavoriteRecipesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _favoriteRecipes = [];

  List<Map<String, dynamic>> get favoriteRecipes => _favoriteRecipes;

  void toggleFavorite(Map<String, dynamic> recipe) {
    if (_favoriteRecipes.contains(recipe)) {
      _favoriteRecipes.remove(recipe);
    } else {
      _favoriteRecipes.add(recipe);
    }
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> recipe) {
    return _favoriteRecipes.contains(recipe);
  }
}
