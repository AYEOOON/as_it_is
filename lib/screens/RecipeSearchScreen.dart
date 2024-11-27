import 'package:flutter/material.dart';
import '../widgets/RecipeSearchItem.dart';
import 'RecipeDetailScreen.dart';

class RecipeSearchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recipes; // 모든 레시피 데이터
  final Function(List<Map<String, dynamic>>) onUpdate; // 업데이트 콜백
  final List<String> selectedMaterials; // 선택된 재료

  RecipeSearchScreen({
    required this.recipes,
    required this.onUpdate,
    required this.selectedMaterials,
  });

  @override
  _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  List<String> categories = ['국', '반찬', '후식', '기타'];
  String? selectedFilter; // 정렬 기준
  late ScrollController scrollController;
  late List<Map<String, dynamic>> filteredRecipes; // 필터링된 레시피 리스트

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    filteredRecipes = widget.recipes; // 초기값은 모든 레시피
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // 정렬 함수
  void sortRecipes(String? criteria) {
    setState(() {
      selectedFilter = criteria;
      if (criteria == 'calories') {
        filteredRecipes.sort((a, b) => a['calories'].compareTo(b['calories']));
      } else if (criteria == 'carbs') {
        filteredRecipes.sort((a, b) => a['carbs'].compareTo(b['carbs']));
      } else if (criteria == 'protein') {
        filteredRecipes.sort((a, b) => a['protein'].compareTo(b['protein']));
      } else if (criteria == 'fat') {
        filteredRecipes.sort((a, b) => a['fat'].compareTo(b['fat']));
      } else if (criteria == 'sodium') {
        filteredRecipes.sort((a, b) => a['sodium'].compareTo(b['sodium']));
      }
    });
  }

  // 즐겨찾기 토글
  void toggleFavorite(int index) {
    setState(() {
      filteredRecipes[index]['isFavorite'] = !filteredRecipes[index]['isFavorite'];
      widget.onUpdate(filteredRecipes); // 부모(Main)로 데이터 업데이트 전달
    });
  }

  // 카테고리 필터 적용
  void applyCategoryFilter(String category) {
    setState(() {
      filteredRecipes = widget.recipes.where((recipe) {
        // 임시 카테고리 필터 (실제 데이터에 따라 수정 필요)
        return recipe['title'].contains(category);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경을 흰색으로 설정
      appBar: AppBar(
        title: const Text(
          '검색된 레시피',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // 선택된 재료와 검색된 레시피 수 표시
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '선택된 재료: ${widget.selectedMaterials.join(", ")}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '검색된 레시피 수: ${filteredRecipes.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const Divider(), // 구분선
              // 카테고리 필터 버튼
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: categories
                      .map((category) => _CategoryButton(
                    label: category,
                    onTap: () => applyCategoryFilter(category),
                  ))
                      .toList(),
                ),
              ),
              // 필터 드롭다운 (커스텀 스타일)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        hint: const Text(
                          '정렬 기준',
                          style: TextStyle(color: Colors.grey),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'calories', child: Text('열량')),
                          DropdownMenuItem(value: 'carbs', child: Text('탄수화물')),
                          DropdownMenuItem(value: 'protein', child: Text('단백질')),
                          DropdownMenuItem(value: 'fat', child: Text('지방')),
                          DropdownMenuItem(value: 'sodium', child: Text('나트륨')),
                        ],
                        onChanged: sortRecipes,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white, // 드롭다운 배경색 설정
                        borderRadius: BorderRadius.circular(8),
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
              ),
              // 검색된 레시피 리스트
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return RecipeSearchItem(
                      title: recipe['title'],
                      imageUrl: recipe['image'], // 이미지 추가
                      ingredients: recipe['nutrition'] != null
                          ? recipe['nutrition'].join('\n') // 개행 추가
                          : '정보 없음',
                      isFavorite: recipe['isFavorite'], // 즐겨찾기 상태
                      onDetailTap: () {
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
                      onBookmarkTap: () {
                        toggleFavorite(index);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.green, // 버튼을 초록색으로 변경
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CategoryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // 버튼을 초록색으로 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
