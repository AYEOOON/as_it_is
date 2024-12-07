import 'dart:convert';
import 'dart:io';

Future<void> createRecipesFromFiles() async {
  try {
    // 파일 읽기 (헤더 제외)
    final names = await File('lib/src/names.txt').readAsLines();
    final images = (await File('lib/src/images.txt').readAsLines()).skip(1).toList();
    final nutritionList = (await File('lib/src/nutrition.txt').readAsLines()).skip(1).toList();
    final ingredientsList = await File('lib/src/ingredients.txt').readAsLines();
    final detailedIngredientsList = await File('lib/src/detailed_ingredients.txt').readAsLines();
    final instructionsRaw = await File('lib/src/instructions.txt').readAsString();
    final categories = await File('lib/src/categories.txt').readAsLines(); // 카테고리 파일 읽기

    final availableCategories = ['국&찌개', '반찬', '후식', '기타'];

    // 전체 일반 재료 리스트
    Set<String> allIngredientsSet = {};

    // 결과 리스트
    List<Map<String, dynamic>> recipes = [];

    // 요리 방법 파싱
    List<List<String>> parsedInstructions = [];
    String currentRecipe = '';
    instructionsRaw.split('\n').forEach((line) {
      if (line.trim().startsWith('1.')) {
        if (currentRecipe.isNotEmpty) {
          parsedInstructions.add(currentRecipe.trim().split('\n').map((e) => e.trim()).toList());
          currentRecipe = '';
        }
      }
      currentRecipe += line + '\n';
    });
    if (currentRecipe.isNotEmpty) {
      parsedInstructions.add(currentRecipe.trim().split('\n').map((e) => e.trim()).toList());
    }

    for (int i = 0; i < names.length; i++) {
      try {
        // 레시피 이름 파싱
        final recipeMatch = RegExp(r'^\d+\.\s*(.+)$').firstMatch(names[i]);
        final recipeName = recipeMatch?.group(1)?.trim() ?? '';

        // 이미지 URL 파싱
        final imageUrls = i < images.length ? images[i].split('\t') : ['', ''];
        final mainImageSmall = imageUrls.isNotEmpty ? imageUrls[0].trim() : '';
        final mainImageLarge = imageUrls.length > 1 ? imageUrls[1].trim() : '';

        // 영양 정보 파싱
        final nutritionData = i < nutritionList.length
            ? nutritionList[i].split(',').map((e) => e.trim()).toList()
            : ['', '0', '0', '0', '0', '0'];
        final calories = double.tryParse(nutritionData.length > 1 ? nutritionData[1] : '0') ?? 0.0;
        final protein = double.tryParse(nutritionData.length > 2 ? nutritionData[2] : '0') ?? 0.0;
        final fat = double.tryParse(nutritionData.length > 3 ? nutritionData[3] : '0') ?? 0.0;
        final carbs = double.tryParse(nutritionData.length > 4 ? nutritionData[4] : '0') ?? 0.0;
        final sodium = double.tryParse(nutritionData.length > 5 ? nutritionData[5] : '0') ?? 0.0;

        // 재료 및 상세 재료 파싱
        final detailedIngredients = i < detailedIngredientsList.length
            ? detailedIngredientsList[i]
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .map((e) => e.replaceFirst(RegExp(r'^\d+\.\s*'), ''))
            .toList()
            : [];
        final ingredientsRaw = i < ingredientsList.length ? ingredientsList[i] : '';
        final ingredients = ingredientsRaw
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .where((e) => RegExp(r'^[가-힣\s]+$').hasMatch(e)) // 한글 필터링
            .where((e) => !e.contains(RegExp(r'(양념장|소스)'))) // 양념장, 소스 제거
            .toList();

        // 전체 재료 리스트에 중복 없이 추가
        ingredients.forEach((ingredient) {
          if (!allIngredientsSet.contains(ingredient.trim())) {
            allIngredientsSet.add(ingredient);
          }
        });

        // 만드는 법 파싱
        final instructions = i < parsedInstructions.length ? parsedInstructions[i] : [];

        // 카테고리 파싱
        String category = i < categories.length ? categories[i].trim() : '기타';
        if (!availableCategories.contains(category)) {
          category = '기타';
        }

        // JSON 객체 생성
        recipes.add({
          'title': recipeName,
          'images': {
            'small': mainImageSmall,
            'large': mainImageLarge,
          },
          'nutrition': {
            'calories': calories,
            'protein': protein,
            'fat': fat,
            'carbs': carbs,
            'sodium': sodium,
          },
          'category': category, // 카테고리 추가
          'ingredients': ingredients,
          'detailedIngredients': detailedIngredients,
          'instructions': instructions,
          'isFavorite': false,
        });
      } catch (e) {
        print('Error processing recipe at line ${i + 1}: $e');
      }
    }

    // 전체 일반 재료 리스트 생성
    final allIngredientsList = allIngredientsSet.toList();

    // JSON 변환 및 저장
    final jsonOutput = JsonEncoder.withIndent('  ').convert({
      'recipes': recipes,
      'allIngredients': allIngredientsList,
    });
    await File('recipes.json').writeAsString(jsonOutput);

    print('Recipes JSON created successfully!');
  } catch (e) {
    print('Error processing files: $e');
  }
}
