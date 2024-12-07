import 'package:flutter/material.dart';

class MaterialProvider with ChangeNotifier {
  List<String> _selectedMaterials = [];
  List<String> _availableMaterials = [];
  List<String> _filteredMaterials = [];

  // Getters
  List<String> get selectedMaterials => _selectedMaterials;
  List<String> get availableMaterials => _availableMaterials;
  List<String> get filteredMaterials => _filteredMaterials;

  // Set available materials and initialize filtered materials
  void setMaterials(List<String> materials) {
    _availableMaterials = List.from(materials)..sort(); // 가나다순 정렬
    _filteredMaterials = List.from(_availableMaterials); // Initialize filtered list
    notifyListeners();
  }

  // Add material to selected and remove from available
  void addMaterial(String material) {
    if (_availableMaterials.contains(material)) {
      _availableMaterials.remove(material);
      _selectedMaterials.add(material);
      _selectedMaterials.sort(); // 가나다순 정렬
      _availableMaterials.sort(); // 정렬 유지
      _filteredMaterials = List.from(_availableMaterials); // Refresh filtered list
      notifyListeners();
    }
  }

  // Remove material from selected and add back to available
  void removeMaterial(String material) {
    if (_selectedMaterials.contains(material)) {
      _selectedMaterials.remove(material);
      _availableMaterials.add(material);
      _selectedMaterials.sort(); // 정렬 유지
      _availableMaterials.sort(); // 정렬 유지
      _filteredMaterials = List.from(_availableMaterials); // Refresh filtered list
      notifyListeners();
    }
  }

  // Filter materials based on search query
  void filterMaterials(String value) {
    _filteredMaterials = _availableMaterials
        .where((material) => material.toLowerCase().contains(value.toLowerCase()))
        .toList()
      ..sort(); // 검색 결과 가나다순 정렬
    notifyListeners();
  }
}
