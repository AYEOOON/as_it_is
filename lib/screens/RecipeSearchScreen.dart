import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AllergyProvider.dart';
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
  List<String> categories = ['국&찌개', '반찬', '후식', '기타'];
  String? selectedFilter; // 정렬 기준
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

  /// 선택된 재료와 알레르기 데이터를 기반으로 레시피를 필터링합니다.
  void _filterRecipes() {
    final allergyProvider = Provider.of<AllergyProvider>(context, listen: false);
    final List<String> excludedIngredients = allergyProvider.getExcludedIngredients();

    setState(() {
      filteredRecipes = widget.recipes.where((recipe) {
        final ingredients = (recipe['ingredients'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
            [];
        final containsSelectedMaterials = widget.selectedMaterials.every(
              (material) => ingredients.any((ingredient) => ingredient.contains(material)),
        );
        final containsExcludedAllergens = excludedIngredients.any(
              (allergen) => ingredients.contains(allergen),
        );

        // 포함된 재료 조건 + 알레르기 제외 조건
        return containsSelectedMaterials && !containsExcludedAllergens;
      }).toList();
    });
  }

  /// 정렬 기준에 따라 레시피를 정렬합니다.
  void sortRecipes(String? criteria) {
    setState(() {
      selectedFilter = criteria;
      if (criteria == 'calories') {
        filteredRecipes.sort((a, b) => a['nutrition']['calories']
            .compareTo(b['nutrition']['calories']));
      } else if (criteria == 'carbs') {
        filteredRecipes.sort((a, b) =>
            a['nutrition']['carbs'].compareTo(b['nutrition']['carbs']));
      } else if (criteria == 'protein') {
        filteredRecipes.sort((a, b) =>
            a['nutrition']['protein'].compareTo(b['nutrition']['protein']));
      } else if (criteria == 'fat') {
        filteredRecipes.sort((a, b) =>
            a['nutrition']['fat'].compareTo(b['nutrition']['fat']));
      } else if (criteria == 'sodium') {
        filteredRecipes.sort((a, b) =>
            a['nutrition']['sodium'].compareTo(b['nutrition']['sodium']));
      }
    });
  }

  /// 즐겨찾기 상태를 토글합니다.
  void toggleFavorite(int index) {
    setState(() {
      filteredRecipes[index]['isFavorite'] =
      !(filteredRecipes[index]['isFavorite'] ?? false);
      widget.onUpdate(widget.recipes); // 부모(Main)로 데이터 업데이트 전달
    });
  }

  /// 카테고리 필터 적용
  void applyCategoryFilter(String category) {
    setState(() {
      filteredRecipes = widget.recipes.where((recipe) {
        final recipeCategory = recipe['category'] ?? '기타';
        return recipeCategory == category;
      }).toList();
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
              children: categories
                  .map((category) => _CategoryButton(
                label: category,
                onTap: () => applyCategoryFilter(category),
              ))
                  .toList(),
            ),
          ),
          // 필터 드롭다운
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
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    dropdownColor: Colors.white,
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
          backgroundColor: Colors.green,
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
