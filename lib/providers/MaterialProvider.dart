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
    _availableMaterials = List.from(materials);
    _filteredMaterials = List.from(materials); // Initialize filtered list
    notifyListeners();
  }

  // Add material to selected and remove from available
  void addMaterial(String material) {
    if (_availableMaterials.contains(material)) {
      _availableMaterials.remove(material);
      _selectedMaterials.add(material);
      _filteredMaterials = List.from(_availableMaterials); // Refresh filtered list
      notifyListeners();
    }
  }

  // Remove material from selected and add back to available
  void removeMaterial(String material) {
    if (_selectedMaterials.contains(material)) {
      _selectedMaterials.remove(material);
      _availableMaterials.add(material);
      _availableMaterials.sort(); // Sort the list
      _filteredMaterials = List.from(_availableMaterials); // Refresh filtered list
      notifyListeners();
    }
  }

  // Filter materials based on search query
  void filterMaterials(String value) {
    _filteredMaterials = _availableMaterials
        .where((material) => material.toLowerCase().contains(value.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
