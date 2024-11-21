import 'package:flutter/material.dart';
import '../widgets/setting_item.dart';
import '../widgets/section_header.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '설정',
          style: TextStyle(
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
