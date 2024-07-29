import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  List<String> _categories = [
    'ເຂົ້າ',
    'ແກງ',
    'ທອດ',
    'ຜັດ',
    'ເສັ້ນ',
    'ຈຸ່ມ&ດາດ',
    'ໝູ',
    'ທະເລ',
    'ໄກ່',
    'ງົວ'
  ];
  List<String> _selectedCategories = [];

  CategoryProvider() {
    _loadSelectedCategories();
  }

  List<String> get categories => _categories;
  List<String> get selectedCategories => _selectedCategories;

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    _saveSelectedCategories();
    notifyListeners();
  }

  void _saveSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedCategories', _selectedCategories);
  }

  void _loadSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? categories = prefs.getStringList('selectedCategories');
    if (categories != null) {
      _selectedCategories = categories;
      notifyListeners();
    }
  }
}
