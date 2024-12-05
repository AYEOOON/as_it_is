import 'package:flutter/material.dart';
import 'ReusableButton.dart';

class RecipeSearchItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String ingredients;
  final VoidCallback onDetailTap;
  final VoidCallback onBookmarkTap;
  final bool isFavorite; // 즐겨찾기 상태
  final List<String> nutrition; // 추가된 영양 정보 필드

  const RecipeSearchItem({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.onDetailTap,
    required this.onBookmarkTap,
    this.isFavorite = false, // 기본값: 즐겨찾기 아님
    this.nutrition = const [], // 기본값: 빈 영양 정보 리스트
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // 카드 배경색을 흰색으로 설정
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 또는 이미지 자리 표시자
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: imageUrl.isEmpty
                    ? const Icon(Icons.image, size: 40, color: Colors.grey)
                    : Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image,
                      size: 40, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 레시피 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 요리 이름
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 재료 정보
                  Text(
                    ingredients,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 영양 정보
                  if (nutrition.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: nutrition
                          .map(
                            (info) => Chip(
                          label: Text(
                            info,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.green, // 칩 색상
                        ),
                      )
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                  ],
                  // 레시피 상세 정보 버튼
                  ReusableButton(
                    label: '레시피 상세 정보',
                    isSelected: false,
                    onTap: onDetailTap,
                  ),
                ],
              ),
            ),
            // 즐겨찾기 버튼
            IconButton(
              onPressed: onBookmarkTap,
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.yellow : Colors.grey,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
