import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // 초기 화면(홈)의 인덱스 설정

  // 화면 목록
  final List<Widget> _screens = [
    BookmarkScreen(), // 즐겨찾기 화면
    HomeScreen(), // 홈 화면 (검색)
    SettingsScreen(), // 설정 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // 현재 선택된 화면 표시
      bottomNavigationBar: Container(
        color: Colors.green, // 기본 네비게이션 바 배경색
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              label: '즐겨찾기',
              icon: Icons.favorite, // 즐겨찾기 아이콘
            ),
            _buildNavItem(
              index: 1,
              label: '검색',
              icon: Icons.search, // 검색 아이콘
            ),
            _buildNavItem(
              index: 2,
              label: '설정',
              icon: Icons.settings, // 설정 아이콘
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index; // 선택된 탭 업데이트
          });
        },
        child: Container(
          color: _currentIndex == index
              ? Colors.lightGreen
              : Colors.green, // 선택된 탭은 연두색
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white), // 아이콘 흰색
              const SizedBox(height: 4), // 아이콘과 텍스트 사이 간격
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white, // 텍스트 흰색
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 검색 화면 (홈)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 앱바 배경색 제거
        elevation: 0, // 그림자 제거
        title: const Text(
          '나의 재료',
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: 20, // 글자 크기
          ),
        ),
        centerTitle: false, // 제목 좌측 정렬
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3, // 한 줄에 3개의 박스
              crossAxisSpacing: 12, // 박스 간의 가로 간격
              mainAxisSpacing: 12, // 박스 간의 세로 간격
              padding: const EdgeInsets.all(16),
              children: const [
                MaterialItem(label: '재료1'),
                MaterialItem(label: '재료2'),
                MaterialItem(label: '재료3'),
                MaterialItem(label: '재료4'),
                MaterialItem(label: '재료5'),
                MaterialItem(label: '재료6'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print('레시피 찾기 버튼 클릭');
            },
            child: const Text('레시피 찾기'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              print('추가 버튼 클릭');
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// 즐겨찾기 화면
class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 앱바 배경색 제거
        elevation: 0, // 그림자 제거
        title: const Text(
          '즐겨찾기',
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: 20, // 글자 크기
          ),
        ),
        centerTitle: false, // 제목 좌측 정렬
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          RecipeItem(title: '레시피 1'),
          RecipeItem(title: '레시피 2'),
          RecipeItem(title: '레시피 3'),
        ],
      ),
    );
  }
}

// 설정 화면
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 앱바 배경색 제거
        elevation: 0, // 그림자 제거
        title: const Text(
          '설정',
          style: TextStyle(
            color: Colors.black, // 텍스트 색상
            fontSize: 20, // 글자 크기
          ),
        ),
        centerTitle: false, // 제목 좌측 정렬
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: '사용자 맞춤'),
          SettingItem(
            label: '알러지 재료 설정',
            value: '2개',
            onTap: () {
              print('알러지 재료 설정 클릭');
            },
          ),
          const SectionHeader(title: '계정'),
          SettingItem(
            label: '아이디',
            value: 'kumoh!00',
            onTap: () {
              print('아이디 클릭');
            },
          ),
          SettingItem(
            label: '비밀번호 변경',
            onTap: () {
              print('비밀번호 변경 클릭');
            },
          ),
          const SectionHeader(title: '앱 설정'),
          SettingItem(
            label: '다크 모드',
            value: '꺼짐',
            onTap: () {
              print('다크 모드 클릭');
            },
          ),
          const SectionHeader(title: '기타'),
          SettingItem(
            label: '회원 탈퇴',
            onTap: () {
              print('회원 탈퇴 클릭');
            },
          ),
          SettingItem(
            label: '로그아웃',
            onTap: () {
              print('로그아웃 클릭');
            },
          ),
        ],
      ),
    );
  }
}

// 재료 아이템 위젯
class MaterialItem extends StatelessWidget {
  final String label;

  const MaterialItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label),
    );
  }
}

// 레시피 아이템 위젯
class RecipeItem extends StatelessWidget {
  final String title;

  const RecipeItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: const Text('요리에 필요한 재료 갯수\n요리에 필요한 재료 목록'),
        trailing: const Icon(Icons.star, color: Colors.amber),
        isThreeLine: true,
      ),
    );
  }
}

// 설정 아이템 위젯
class SettingItem extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const SettingItem({
    required this.label,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: value != null ? Text(value!) : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

// 섹션 헤더 위젯
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
