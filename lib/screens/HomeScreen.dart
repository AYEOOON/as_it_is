import 'package:flutter/material.dart';
import 'RecipeSearchScreen.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recipes;
  final Function(List<Map<String, dynamic>>) onUpdate;

  HomeScreen({required this.recipes, required this.onUpdate});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> materials = ['재료1', '재료2', '양파', '감자', '파', '고추', '마늘'];
  List<String> unaddedMaterials = ['재료3', '재료4'];
  List<String> filteredMaterials = [];
  TextEditingController searchController = TextEditingController();
  bool isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    filteredMaterials = [...materials, ...unaddedMaterials];
  }

  void onSearch(String query) {
    setState(() {
      filteredMaterials = [
        ...materials,
        ...unaddedMaterials,
      ].where((material) => material.contains(query)).toList();
      isDropdownVisible = true;
    });
  }

  void onAddItem(String item) {
    if (unaddedMaterials.contains(item)) {
      setState(() {
        unaddedMaterials.remove(item);
        materials.add(item);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$item 이(가) 추가되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$item 이미 추가되어 있습니다.')),
      );
    }
  }

  void onRemoveItem(String item) {
    if (materials.contains(item)) {
      setState(() {
        materials.remove(item);
        unaddedMaterials.add(item);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$item 이(가) 삭제되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          setState(() {
            isDropdownVisible = false;
          });
        },
        child: Stack(
          children: [
            Column(
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
                      if (value.isNotEmpty) {
                        onSearch(value);
                      } else {
                        setState(() {
                          isDropdownVisible = false;
                        });
                      }
                    },
                    onTap: () {
                      setState(() {
                        isDropdownVisible = true;
                        filteredMaterials = [...materials, ...unaddedMaterials];
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
                // 추가된 재료 리스트
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
                              String removedItem = materials[index];
                              onRemoveItem(removedItem);
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
                // 레시피 검색 버튼
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeSearchScreen(
                            recipes: widget.recipes, // Main에서 전달된 recipes
                            onUpdate: widget.onUpdate, // Main으로 업데이트 전달
                            selectedMaterials: materials, // 선택된 재료 전달
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
            // 드롭다운 리스트
            if (isDropdownVisible)
              Positioned(
                top: 160,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: filteredMaterials.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          '검색 결과가 없습니다.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredMaterials.length,
                      itemBuilder: (context, index) {
                        String item = filteredMaterials[index];
                        bool isInMaterials = materials.contains(item);
                        return ListTile(
                          leading: Icon(
                            isInMaterials ? Icons.check : Icons.add,
                            color: isInMaterials ? Colors.blue : Colors.green,
                          ),
                          title: Text(item),
                          onTap: () {
                            if (!isInMaterials) {
                              onAddItem(item);
                            }
                            setState(() {
                              isDropdownVisible = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
