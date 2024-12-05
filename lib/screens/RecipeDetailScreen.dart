import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AllergyProvider.dart';
import '../services/openai_service.dart';


class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    required this.recipe,
  });

  void _fetchSubstitute(BuildContext context, String ingredient) async {
    final allergyProvider = Provider.of<AllergyProvider>(context, listen: false);
    final excludedIngredients = allergyProvider.getExcludedIngredients();

    final openAIService = OpenAIService();
    // OpenAI API 호출
    try {
      final substitute = await openAIService.sendMessage(recipe['title'], ingredient, excludedIngredients);
      _showSubstituteDialog(context, ingredient, substitute);
    } catch (error) {
      _showErrorDialog(context, "대체 재료를 불러오지 못했습니다.");
    }
  }

  void _showSubstituteDialog(BuildContext context, String ingredient, String substitute) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$ingredient 대체재'),
          content: Text('$ingredient를 대신할 재료로 $substitute을 추천합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('오류'),
          content: Text('대체 재료를 가져오는 중 문제가 발생했습니다: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

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
              children: nutritionInfo
                  .map(
                    (info) => Chip(
                  label: Text(
                    info,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black),
                  ),
                  backgroundColor: Colors.green[100],
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
              children: detailedIngredients.map((ingredient) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100],
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      // OpenAIService를 사용하여 대체 재료를 가져오는 함수 호출
                      _fetchSubstitute(context, ingredient);
                    },
                    child: Text(
                      ingredient,
                      style: const TextStyle(fontSize: 16),
                    ),
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
