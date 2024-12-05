import 'package:flutter/material.dart';
import '../widgets/ReusableButton.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    // 데이터 가져오기
    final String title = recipe['title'] ?? '레시피 제목 없음';
    final String imageUrl = recipe['images']?['large'] ?? ''; // 큰 이미지 URL
    final Map<String, dynamic> nutrition = recipe['nutrition'] ?? {};
    final List<String> nutritionInfo = [
      '${nutrition['calories'] ?? 0}kcal 열량',
      '${nutrition['carbs'] ?? 0}g 탄수화물',
      '${nutrition['protein'] ?? 0}g 단백질',
      '${nutrition['fat'] ?? 0}g 지방',
      '${nutrition['sodium'] ?? 0}mg 나트륨'
    ];
    final List<String> detailedIngredients =
    List<String>.from(recipe['detailedIngredients'] ?? []);
    final List<String> instructions =
    List<String>.from(recipe['instructions'] ?? []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 16),
            // 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: _isValidNetworkImage(imageUrl)
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Text('이미지 로드 실패')),
                )
                    : const Center(
                  child: Text(
                    '이미지가 없습니다',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 영양정보
            const Text(
              '영양정보',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: nutritionInfo.map(
                    (info) {
                  return ReusableButton(
                    label: info,
                    isSelected: false,
                    onTap: () {},
                  );
                },
              ).toList(),
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
              children: detailedIngredients.map((ingredient) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    ingredient,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                );
              }).toList(),
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
              children: instructions.map((step) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    step,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidNetworkImage(String url) {
    // URL이 비어있거나 file://로 시작하면 유효하지 않은 것으로 간주
    return url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true;
  }
}
