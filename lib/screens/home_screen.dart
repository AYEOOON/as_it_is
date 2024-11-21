import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 재료 리스트
  List<String> materials = ['재료1', '재료2', '재료3', '재료4', '재료5', '재료6'];

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
            child: ListView.builder(
              itemCount: materials.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(materials[index]), // 고유 키로 재료 이름 사용
                  direction: DismissDirection.endToStart, // 오른쪽에서 왼쪽으로 스와이프
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red, // 스와이프 시 배경색
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white), // 삭제 아이콘
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      materials.removeAt(index); // 재료 삭제
                    });

                    // 삭제 완료 메시지
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('삭제되었습니다: ${materials[index]}')),
                    );
                  },
                  child: ListTile(
                    title: Text(materials[index]),
                    tileColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.black12),
                    ),
                  ),
                );
              },
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
