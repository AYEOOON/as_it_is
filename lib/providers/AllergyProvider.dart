import 'package:flutter/material.dart';

class AllergyProvider with ChangeNotifier {
  final List<String> _allergyItems = [
    '난류',
    '대두',
    '우유',
    '곡류',
    '감각류',
    '견과류',
    '생선류',
    '연체류',
    '아황산류',
    '육류',
  ];

  // 알러지 항목별 포함된 재료
  final Map<String, List<String>> _categorizedIngredients = {
    '난류': ['계란', '메추리알', '오리알'],
    '대두': ['콩', '두부', '된장', '간장'],
    '우유': ['우유', '요구르트', '치즈', '버터'],
    '곡류': ['쌀', '밀', '보리', '옥수수'],
    '감각류': ['감자', '고구마', '마'],
    '견과류': ['아몬드', '호두', '캐슈넛', '땅콩'],
    '생선류': ['고등어', '참치', '연어', '명태'],
    '연체류': ['오징어', '문어', '조개'],
    '아황산류': ['건포도', '와인', '식초'],
    '육류': ['소고기', '돼지고기', '닭고기', '양고기'],
  };

  late List<bool> _isSelected;

  AllergyProvider() {
    _isSelected = List.generate(_allergyItems.length, (index) => false);
  }

  List<String> get allergyItems => _allergyItems;
  List<bool> get isSelected => _isSelected;

  int get selectedAllergyCount =>
      _isSelected.where((selected) => selected).length;

  void updateSelection(int index, bool value) {
    _isSelected[index] = value;
    notifyListeners();
  }

  /// 선택된 알러지 항목에 해당하는 재료를 반환
  List<String> getExcludedIngredients() {
    List<String> excludedIngredients = [];

    for (int i = 0; i < _allergyItems.length; i++) {
      if (_isSelected[i]) {
        excludedIngredients.addAll(_categorizedIngredients[_allergyItems[i]] ?? []);
      }
    }

    return excludedIngredients;
  }
}
