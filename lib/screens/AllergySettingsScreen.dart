import 'package:flutter/material.dart';

class AllergySettingsScreen extends StatefulWidget {
  @override
  _AllergySettingsScreenState createState() => _AllergySettingsScreenState();
}

class _AllergySettingsScreenState extends State<AllergySettingsScreen> {
  final List<String> allergyItems = [
    '난류',
    '대두',
    '우유',
    '곡류',
    '감각류',
    '견과류',
    '생선류',
    '연체류',
    '아황산류',
    '육류',
  ];

  final List<bool> isSelected = List.generate(10, (index) => false); // 선택 상태 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색으로 설정
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '알러지 유발 식품 목록',
          style: TextStyle(color: Colors.black,
            fontWeight: FontWeight.bold,),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allergyItems.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(
              allergyItems[index],
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            value: isSelected[index],
            onChanged: (bool? value) {
              setState(() {
                isSelected[index] = value ?? false;
              });
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.lightGreen[100],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '즐겨찾기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
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
