import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {
  final String title;

  const RecipeItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: const Text('요리에 필요한 재료 갯수\n요리에 필요한 재료 목록'),
        trailing: const Icon(Icons.star, color: Colors.amber),
        isThreeLine: true,
      ),
    );
  }
}
