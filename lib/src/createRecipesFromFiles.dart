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
        if (recipeMatch == null) {
          print('Invalid recipe name format at line ${i + 1}');
          continue;
        }
        final recipeName = recipeMatch.group(1)?.trim() ?? '';

        // 이미지 URL 파싱
        if (i >= images.length) {
          print('Missing image data for recipe at line ${i + 1}');
          continue;
        }
        final imageUrls = images[i].split('\t');
        if (imageUrls.length < 2) {
          print('Invalid image format for recipe at line ${i + 1}');
          continue;
        }
        final mainImageSmall = imageUrls[0].trim();
        final mainImageLarge = imageUrls[1].trim();

        // 영양 정보 파싱
        if (i >= nutritionList.length) {
          print('Missing nutrition data for recipe at line ${i + 1}');
          continue;
        }
        final nutritionData = nutritionList[i].split(',').map((e) => e.trim()).toList();
        if (nutritionData.length < 6) {
          print('Invalid nutrition format for recipe at line ${i + 1}');
          continue;
        }
        final calories = int.tryParse(nutritionData[1]) ?? 0;
        final protein = int.tryParse(nutritionData[2]) ?? 0;
        final fat = int.tryParse(nutritionData[3]) ?? 0;
        final carbs = int.tryParse(nutritionData[4]) ?? 0;
        final sodium = int.tryParse(nutritionData[5]) ?? 0;

        // 재료 및 상세 재료 파싱
        if (i >= ingredientsList.length || i >= detailedIngredientsList.length) {
          print('Missing ingredient data for recipe at line ${i + 1}');
          continue;
        }

        // 숫자와 점 제거하여 상세 재료 저장
        final detailedIngredients = detailedIngredientsList[i]
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .map((e) => e.replaceFirst(RegExp(r'^\d+\.\s*'), '')) // 숫자와 점 제거
            .toList();

        // 일반 재료 파싱: 숫자. 이후의 내용을 가져와 , 로 구분
        final ingredientsRaw = ingredientsList[i].replaceFirst(RegExp(r'^\d+\.\s*'), '');
        final ingredients = ingredientsRaw
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        // 전체 재료 리스트에 추가
        allIngredientsSet.addAll(ingredients);

        // 만드는 법 파싱
        if (i >= parsedInstructions.length) {
          print('Missing instructions data for recipe at line ${i + 1}');
          continue;
        }
        final instructions = parsedInstructions[i];

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
          'ingredients': ingredients, // JSON에 한 줄씩 나뉜 일반 재료
          'detailedIngredients': detailedIngredients,
          'instructions': instructions,
          'isFavorite': false, // 즐겨찾기 초기값 설정
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
      'allIngredients': allIngredientsList, // 검색용 전체 재료 리스트
    });
    await File('recipes.json').writeAsString(jsonOutput);

    print('Recipes JSON created successfully!');
  } catch (e) {
    print('Error processing files: $e');
  }
}
