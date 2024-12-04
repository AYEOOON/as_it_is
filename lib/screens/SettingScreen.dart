import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AllergyProvider.dart';
import 'AllergySettingsScreen.dart';
import '../widgets/setting_item.dart';
import '../widgets/section_header.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allergyProvider = Provider.of<AllergyProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '설정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: '사용자 맞춤'),
          SettingItem(
            label: '알러지 재료 설정',
            value: '${allergyProvider.selectedAllergyCount}개', // 알러지 개수 표시
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllergySettingsScreen(),
                ),
              );
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
        ],
      ),
    );
  }
}
