import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final List<String> nutritionInfo;
  final List<String> ingredients;
  final List<String> instructions;

  const RecipeDetailScreen({
    required this.title,
    required this.imageUrl,
    required this.nutritionInfo,
    required this.ingredients,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경을 흰색으로 설정
      appBar: AppBar(
        title: const Text(
          '레시피 상세보기 화면',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 레시피 제목
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: imageUrl.isEmpty
                    ? const Center(
                  child: Text(
                    '요리 사진',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                )
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Text('이미지 로드 실패')),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 영양 정보
            const Text(
              '영양정보',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: nutritionInfo
                  .map(
                    (info) => Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.green[100],
                      child: Text(
                        info,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 24),
            // 필요한 재료
            const Text(
              '필요한 재료',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ingredients
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${entry.key + 1}. ${entry.value}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 24),
            // 만드는 법
            const Text(
              '만드는 법',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: instructions
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${entry.key + 1}. ${entry.value}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
