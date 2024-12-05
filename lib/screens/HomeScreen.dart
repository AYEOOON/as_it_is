import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/MaterialProvider.dart';
import '../widgets/ReusableButton.dart';
import 'RecipeSearchScreen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> allIngredients;
  final List<Map<String, dynamic>> recipes; // Pass recipes data
  final Function(List<Map<String, dynamic>>) onUpdate; // Update callback

  HomeScreen({
    required this.allIngredients,
    required this.recipes,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final materialProvider = Provider.of<MaterialProvider>(context);

    // Initialize available materials if not set
    if (materialProvider.availableMaterials.isEmpty) {
      materialProvider.setMaterials(allIngredients);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '재료 관리',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar for filtering available ingredients
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                materialProvider.filterMaterials(value);
              },
              decoration: InputDecoration(
                hintText: '재료 검색...',
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
          Expanded(
            child: Row(
              children: [
                // Added ingredients
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
                        child: materialProvider.selectedMaterials.isEmpty
                            ? const Center(
                          child: Text(
                            '추가된 재료가 없습니다.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                            : ListView.builder(
                          itemCount:
                          materialProvider.selectedMaterials.length,
                          itemBuilder: (context, index) {
                            final material =
                            materialProvider.selectedMaterials[index];
                            return ListTile(
                              title: Text(material),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () {
                                  materialProvider
                                      .removeMaterial(material);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Colors.grey,
                ),
                // Available ingredients
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
                        child: materialProvider.filteredMaterials.isEmpty
                            ? const Center(
                          child: Text(
                            '검색된 재료가 없습니다.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                            : ListView.builder(
                          itemCount:
                          materialProvider.filteredMaterials.length,
                          itemBuilder: (context, index) {
                            final material =
                            materialProvider.filteredMaterials[index];
                            return ListTile(
                              title: Text(material),
                              trailing: IconButton(
                                icon: const Icon(Icons.add,
                                    color: Colors.green),
                                onPressed: () {
                                  materialProvider.addMaterial(material);
                                },
                              ),
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
        ],
      ),
      // FloatingActionButton with transparent background
      floatingActionButton: ReusableButton(
        label: '레시피 검색',
        isSelected: false, // `isSelected`는 레시피 검색에 필요하지 않으므로 `false` 설정
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeSearchScreen(
                recipes: recipes,
                onUpdate: onUpdate,
                selectedMaterials: materialProvider.selectedMaterials,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const SizedBox(height: 0), // 빈 영역
    );
  }
}
