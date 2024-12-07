import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AllergyProvider.dart';
import '../widgets/RecipeSearchItem.dart';
import 'RecipeDetailScreen.dart';
import '../widgets/ReusableButton.dart';

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
  List<String> categories = ['국&찌개', '반찬', '후식', '기타'];
  String? selectedNutrient; // 선택된 영양소
  String? sortOrder = '오름차순'; // 정렬 순서
  String? selectedCategory; // 선택된 카테고리
  late ScrollController scrollController;
  late List<Map<String, dynamic>> filteredRecipes; // 필터링된 레시피 리스트

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _filterRecipes(); // 선택된 재료와 알레르기 필터를 적용
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // 선택된 재료와 알레르기 데이터를 기반으로 레시피를 필터링
  void _filterRecipes() {
    final allergyProvider = Provider.of<AllergyProvider>(context, listen: false);
    final List<String> excludedIngredients = allergyProvider.getExcludedIngredients();

    setState(() {
      filteredRecipes = widget.recipes.where((recipe) {
        final ingredients = (recipe['ingredients'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
            [];
        final recipeCategory = recipe['category'] ?? '기타';

        // 사용자가 선택한 재료 중 하나라도 포함되어 있는지 확인
        final containsSelectedMaterials = widget.selectedMaterials.any(
              (material) => ingredients.any((ingredient) => ingredient.contains(material)),
        );

        // 알레르기 재료가 포함되어 있는지 확인
        final containsExcludedAllergens = excludedIngredients.any(
                (allergen) => ingredients.any((ingredient) => ingredient.contains(allergen.toLowerCase()))
        );

        // 카테고리 필터 조건
        final matchesCategory = selectedCategory == null || recipeCategory == selectedCategory;

        // 하나라도 포함된 재료 조건 + 알레르기 제외 조건 + 선택된 카테고리 조건
        return containsSelectedMaterials && !containsExcludedAllergens && matchesCategory;
      }).toList();
    });
  }


  // 영양소 및 정렬 순서에 따라 레시피를 정렬
  void sortRecipes() {
    if (selectedNutrient == null) return; // 정렬 기준이 선택되지 않은 경우 종료
    setState(() {
      filteredRecipes.sort((a, b) {
        final valueA = a['nutrition'][selectedNutrient] ?? 0;
        final valueB = b['nutrition'][selectedNutrient] ?? 0;
        if (sortOrder == '오름차순') {
          return valueA.compareTo(valueB);
        } else {
          return valueB.compareTo(valueA);
        }
      });
    });
  }

  // 즐겨찾기 상태를 토글
  void toggleFavorite(int index) {
    setState(() {
      filteredRecipes[index]['isFavorite'] =
      !(filteredRecipes[index]['isFavorite'] ?? false);
      widget.onUpdate(widget.recipes); // 부모(Main)로 데이터 업데이트 전달
    });
  }

  // 카테고리 필터 적용
  void applyCategoryFilter(String category) {
    setState(() {
      selectedCategory = category == selectedCategory ? null : category;
      _filterRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Column(
        children: [
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
          const Divider(),
          // 카테고리 필터 버튼
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: categories.map((category) {
                return ReusableButton(
                  label: category,
                  isSelected: selectedCategory == category,
                  onTap: () => applyCategoryFilter(category),
                );
              }).toList(),
            ),
          ),
          // 정렬 필터 드롭다운
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 영양소 기준 선택
                DropdownButton<String>(
                  value: selectedNutrient,
                  hint: const Text(
                    '정렬 기준',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'calories',
                      child: Text('열량', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'carbs',
                      child: Text('탄수화물', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'protein',
                      child: Text('단백질', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'fat',
                      child: Text('지방', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'sodium',
                      child: Text('나트륨', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedNutrient = value;
                      sortRecipes();
                    });
                  },
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  dropdownColor: Colors.white,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  alignment: Alignment.center,
                  iconSize: 20,
                ),
                // 정렬 순서 선택
                DropdownButton<String>(
                  value: sortOrder,
                  items: const [
                    DropdownMenuItem(
                      value: '오름차순',
                      child: Text('오름차순', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: '내림차순',
                      child: Text('내림차순', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      sortOrder = value;
                      sortRecipes();
                    });
                  },
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  dropdownColor: Colors.white,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  alignment: Alignment.center,
                  iconSize: 20,
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
                  imageUrl: recipe['images']?['small'] ?? '',
                  ingredients: recipe['nutrition'] != null
                      ? [
                    '열량: ${recipe['nutrition']['calories']} kcal',
                    '탄수화물: ${recipe['nutrition']['carbs']}g',
                    '단백질: ${recipe['nutrition']['protein']}g',
                    '지방: ${recipe['nutrition']['fat']}g',
                    '나트륨: ${recipe['nutrition']['sodium']}mg',
                  ].join('\n')
                      : '정보 없음',
                  isFavorite: recipe['isFavorite'] ?? false,
                  onDetailTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipe: recipe,
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
      ),
    );
  }
}