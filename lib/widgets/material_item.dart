import 'package:flutter/material.dart';

class MaterialItem extends StatelessWidget {
  final String label;

  const MaterialItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label),
    );
  }
}
