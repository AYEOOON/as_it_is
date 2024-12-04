import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AllergyProvider.dart';

class AllergySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allergyProvider = Provider.of<AllergyProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          '알러지 유발 식품 목록',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allergyProvider.allergyItems.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(
              allergyProvider.allergyItems[index],
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            value: allergyProvider.isSelected[index],
            onChanged: (bool? value) {
              allergyProvider.updateSelection(index, value ?? false);
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          );
        },
      ),
    );
  }
}
