import 'package:flutter/material.dart';
import 'package:food_recommend_fontend/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'food_list_screen.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Select Food Categories',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 169, 40),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, index) {
          final category = categoryProvider.categories[index];
          final isSelected =
              categoryProvider.selectedCategories.contains(category);
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 6),
            child: CheckboxListTile(
              title: Text(category, style: TextStyle(fontSize: 18)),
              value: isSelected,
              onChanged: (value) {
                categoryProvider.toggleCategory(category);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Color.fromARGB(255, 255, 169, 40),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodListScreen(
                selectedCategories: categoryProvider.selectedCategories,
              ),
            ),
          );
        },
      ),
    );
  }
}
