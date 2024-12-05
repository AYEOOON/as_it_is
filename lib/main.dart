import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/HomeScreen.dart';
import 'screens/FavoriteRecipesScreen.dart';
import 'screens/SettingScreen.dart';
import 'providers/AllergyProvider.dart';
import 'providers/MaterialProvider.dart';
import 'src/createRecipesFromFiles.dart'; // JSON 생성 함수 파일 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();  // .env 파일 로드
  // JSON 생성 후 실행
  await createRecipesFromFiles(); // JSON 데이터 생성

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AllergyProvider()), // 알러지 상태 관리
        ChangeNotifierProvider(create: (_) => MaterialProvider()), // 재료 상태 관리
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // 초기 화면은 검색 화면
  List<Map<String, dynamic>> recipes = []; // 레시피 데이터 저장
  List<String> allIngredients = []; // 전체 재료 데이터 저장
  late List<Widget> _screens; // 화면 리스트

  @override
  void initState() {
    super.initState();
    _loadData(); // JSON 데이터 불러오기
  }

  // JSON 데이터를 로드하는 함수
  Future<void> _loadData() async {
    try {
      final file = File('recipes.json'); // JSON 파일 경로
      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(jsonData);

        setState(() {
          recipes = List<Map<String, dynamic>>.from(data['recipes']);
          allIngredients = List<String>.from(data['allIngredients']);
        });

        // 전역 재료 데이터 초기화
        final materialProvider = Provider.of<MaterialProvider>(context, listen: false);
        materialProvider.setMaterials(allIngredients);
      } else {
        print('recipes.json not found. Using default recipes.');
      }
    } catch (e) {
      print('Error loading recipes: $e');
    }

    _initializeScreens();
  }

  // 각 화면 초기화
  void _initializeScreens() {
    _screens = [
      FavoriteRecipesScreen(
        recipes: recipes,
        onUpdate: _updateRecipes,
      ),
      HomeScreen(
        allIngredients: allIngredients, // 전체 재료 리스트 전달
        recipes: recipes,
        onUpdate: _updateRecipes,
      ),
      SettingsScreen(),
    ];
  }

  // 레시피 업데이트 함수
  void _updateRecipes(List<Map<String, dynamic>> updatedRecipes) {
    setState(() {
      recipes = updatedRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: recipes.isEmpty
          ? const Center(child: CircularProgressIndicator()) // 로딩 화면
          : _screens[_currentIndex], // 현재 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.lightGreen[100],
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