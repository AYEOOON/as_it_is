import 'package:flutter/material.dart';
import '../widgets/material_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '나의 재료',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
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
