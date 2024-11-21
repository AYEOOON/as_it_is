import 'package:flutter/material.dart';
import '../widgets/recipe_item.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '즐겨찾기',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          RecipeItem(title: '레시피 1'),
          RecipeItem(title: '레시피 2'),
          RecipeItem(title: '레시피 3'),
        ],
      ),
    );
  }
}
