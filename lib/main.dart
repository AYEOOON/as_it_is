import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'screens/FavoriteRecipesScreen.dart';
import 'screens/SettingScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Main(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 초기 레시피 데이터
final List<Map<String, dynamic>> testRecipes = [
  {
    'title': '김치찌개',
    'image': '',
    'isFavorite': true,
    'nutrition': ['20g 탄수화물', '5g 단백질', '3g 지방', '200mg 나트륨'],
    'calories': 300, // 추가된 열량
    'carbs': 20, // 추가된 탄수화물
    'protein': 5, // 추가된 단백질
    'fat': 3, // 추가된 지방
    'sodium': 200, // 추가된 나트륨
    'ingredients': ['김치', '돼지고기', '양파', '대파'],
    'instructions': ['1. 김치를 준비합니다.', '2. 돼지고기를 볶습니다.', '3. 끓입니다.'],
  },
  {
    'title': '된장찌개',
    'image': '',
    'isFavorite': false,
    'nutrition': ['15g 탄수화물', '6g 단백질', '2g 지방', '180mg 나트륨'],
    'calories': 250,
    'carbs': 15,
    'protein': 6,
    'fat': 2,
    'sodium': 180,
    'ingredients': ['된장', '감자', '애호박', '두부'],
    'instructions': [
      '1. 감자와 애호박을 썹니다.',
      '2. 된장을 풀어 끓입니다.',
      '3. 완성합니다.'
    ],
  },
  {
    'title': '비빔밥',
    'image': '',
    'isFavorite': false,
    'nutrition': ['30g 탄수화물', '10g 단백질', '5g 지방', '250mg 나트륨'],
    'calories': 500,
    'carbs': 30,
    'protein': 10,
    'fat': 5,
    'sodium': 250,
    'ingredients': ['밥', '나물', '고추장', '계란'],
    'instructions': [
      '1. 밥을 준비합니다.',
      '2. 나물을 볶습니다.',
      '3. 고추장을 곁들입니다.'
    ],
  },
];



class Main extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<Main> {
  int _currentIndex = 1;

  List<Map<String, dynamic>> recipes = List.from(testRecipes);

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      FavoriteRecipesScreen(
        recipes: recipes,
        onUpdate: _updateRecipes,
      ),
      HomeScreen(
        recipes: recipes,
        onUpdate: _updateRecipes,
      ),
      SettingsScreen(),
    ];
  }

  void _updateRecipes(List<Map<String, dynamic>> updatedRecipes) {
    setState(() {
      recipes = updatedRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.green,
        // 네비게이션 바 배경 색상
        selectedItemColor: Colors.white,
        // 선택된 아이템 색상
        unselectedItemColor: Colors.lightGreen[100],
        // 선택되지 않은 아이템 색상
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '즐겨찾기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
