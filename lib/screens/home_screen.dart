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
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  print('레시피 찾기 버튼 클릭');
                },
                child: const Text('레시피 찾기'),
              ),
              FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('추가 버튼이 클릭되었습니다!')),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
