import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const SettingItem({
    required this.label,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: value != null ? Text(value!) : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
