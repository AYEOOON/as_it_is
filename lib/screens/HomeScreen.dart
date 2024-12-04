import 'package:flutter/material.dart';

import 'RecipeSearchScreen.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recipes;
  final List<String> allIngredientsList; // 전체 재료 리스트 추가
  final Function(List<Map<String, dynamic>>) onUpdate;

  HomeScreen({
    required this.recipes,
    required this.allIngredientsList, // 생성자에서 전달받음
    required this.onUpdate,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> materials = []; // 추가된 재료
  List<String> unaddedMaterials = []; // 추가되지 않은 재료
  List<String> filteredMaterials = []; // 검색된 재료
  TextEditingController searchController = TextEditingController();
  bool isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeIngredients(); // 초기 재료 리스트 설정
  }

  // 초기 재료 리스트 설정
  void _initializeIngredients() {
    setState(() {
      unaddedMaterials = List<String>.from(widget.allIngredientsList)..sort(); // 정렬
      filteredMaterials = List.from(unaddedMaterials); // 검색 가능한 리스트 초기화
    });
  }

  void onSearch(String query) {
    setState(() {
      // 검색 조건에 맞고 이미 추가되지 않은 재료만 필터링
      filteredMaterials = unaddedMaterials
          .where((material) => material.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isDropdownVisible = query.isNotEmpty;
    });
  }

  void onAddItem(String item) {
    if (unaddedMaterials.contains(item)) {
      setState(() {
        unaddedMaterials.remove(item);
        materials.add(item);
        filteredMaterials = List.from(unaddedMaterials); // 드롭다운 갱신
      });
      _showMessage('$item 이(가) 추가되었습니다.');
    }
  }

  void onRemoveItem(String item) {
    if (materials.contains(item)) {
      setState(() {
        materials.remove(item);
        unaddedMaterials.add(item);
        unaddedMaterials.sort(); // 정렬 유지
        filteredMaterials = List.from(unaddedMaterials); // 드롭다운 갱신
      });
      _showMessage('$item 이(가) 삭제되었습니다.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1200), // 적절한 지속시간
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          setState(() {
            isDropdownVisible = false; // 드롭다운 숨김
          });
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
              child: Text(
                '나의 재료',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // 검색창
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  onSearch(value);
                },
                onTap: () {
                  setState(() {
                    isDropdownVisible = true;
                    filteredMaterials = List.from(unaddedMaterials); // 검색 초기화
                  });
                },
                decoration: InputDecoration(
                  hintText: '재료 검색',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // 재료 리스트 스크롤 가능하게 설정
            Expanded(
              child: Row(
                children: [
                  // 추가된 재료 목록
                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '추가된 재료',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: materials.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Dismissible(
                                    key: Key(materials[index]),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      color: Colors.red,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    onDismissed: (direction) {
                                      onRemoveItem(materials[index]);
                                    },
                                    child: ListTile(
                                      title: Text(materials[index]),
                                      tileColor: Colors.green[50],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1, color: Colors.grey),
                  // 가용 재료 목록
                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '가용 재료',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredMaterials.length,
                            itemBuilder: (context, index) {
                              String item = filteredMaterials[index];
                              return ListTile(
                                leading: const Icon(Icons.add, color: Colors.green),
                                title: Text(item),
                                onTap: () {
                                  onAddItem(item);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 레시피 검색 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeSearchScreen(
                        recipes: widget.recipes,
                        onUpdate: widget.onUpdate,
                        selectedMaterials: materials,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '레시피 검색',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
