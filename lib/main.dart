<<<<<<< Updated upstream
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
=======
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
>>>>>>> Stashed changes
