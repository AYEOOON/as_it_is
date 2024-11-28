import 'package:flutter/material.dart';
import 'RecipeDetailScreen.dart';

class FavoriteRecipesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recipes;
  final Function(List<Map<String, dynamic>>) onUpdate;

  FavoriteRecipesScreen({
    required this.recipes,
    required this.onUpdate,
  });

  @override
  _FavoriteRecipesScreenState createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> {
  List<Map<String, dynamic>> favoriteRecipes = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _filterFavorites();
  }

  // 즐겨찾기 필터링
  void _filterFavorites() {
    setState(() {
      favoriteRecipes = widget.recipes
          .where((recipe) =>
      recipe['isFavorite'] == true &&
          recipe['title']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  // 즐겨찾기 상태 변경
  void _toggleFavorite(Map<String, dynamic> recipe) {
    setState(() {
      recipe['isFavorite'] = !(recipe['isFavorite'] ?? false);
      widget.onUpdate(widget.recipes); // Main에 업데이트를 반영
      _filterFavorites(); // 즐겨찾기 목록 갱신
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색
      appBar: AppBar(
        title: const Text(
          '북마크',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterFavorites();
                });
              },
              decoration: InputDecoration(
                hintText: '찾고자 하는 요리 이름',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // 즐겨찾기된 레시피 리스트
          Expanded(
            child: favoriteRecipes.isEmpty
                ? const Center(
              child: Text(
                '즐겨찾기한 레시피가 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Card(
                  color: Colors.white, // 카드 배경 흰색
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.grey[200],
                        width: 60,
                        height: 60,
                        child: (recipe['image'] ?? '').isEmpty
                            ? const Icon(Icons.image,
                            size: 40, color: Colors.grey)
                            : Image.network(
                          recipe['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image,
                              size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(
                      recipe['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text(
                      '주요 재료 표시 가능',
                      style:
                      TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        recipe['isFavorite'] == true
                            ? Icons.star
                            : Icons.star_border,
                        color: recipe['isFavorite'] == true
                            ? Colors.yellow
                            : Colors.grey,
                      ),
                      onPressed: () {
                        _toggleFavorite(recipe);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(
                            title: recipe['title'],
                            imageUrl: recipe['image'] ?? '',
                            nutritionInfo: recipe['nutrition'] ?? [],
                            ingredients: recipe['ingredients'] ?? [],
                            instructions: recipe['instructions'] ?? [],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
