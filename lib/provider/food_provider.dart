// import 'package:flutter/material.dart';
// import 'package:food_recommend_fontend/api_service.dart';

// class FoodProvider extends ChangeNotifier {
//   List<dynamic> _foodItems = [];

//   List<dynamic> get foodItems => _foodItems;

//   List<dynamic> filterByCategory(List<String> selectedCategories) {
//     if (selectedCategories.isEmpty) {
//       return _foodItems;
//     }
//     return _foodItems.where((item) {
//       return selectedCategories.any((category) => item['categories'] != null && item['categories'].contains(category));
//     }).toList();
//   }

//   List<dynamic> searchFoodItems(String query) {
//     if (query.isEmpty) {
//       return _foodItems;
//     }
//     return _foodItems.where((item) {
//       return item['name'] != null && item['name'].toLowerCase().contains(query.toLowerCase());
//     }).toList();
//   }

//   void setFoodItems(List<dynamic> items) {
//     _foodItems = items;
//     notifyListeners();
//   }

//   Future<void> fetchFoodItems() async {
//     try {
//       List<dynamic> items = await ApiService.fetchData('sheet1', {});
//       setFoodItems(items);
//     } catch (e) {
//       print('Failed to fetch food items: $e');
//     }
//   }
// }
