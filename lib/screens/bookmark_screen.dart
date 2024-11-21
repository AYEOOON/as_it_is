import 'package:flutter/material.dart';
import '../widgets/recipe_item.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 앱바 배경색 제거
        elevation: 0, // 그림자 제거
        title: const Text(
          '즐겨찾기',
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: 20, // 글자 크기
          ),
        ),
        centerTitle: false, // 제목 좌측 정렬
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
